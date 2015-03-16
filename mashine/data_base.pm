#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use DBI;
    use mashine_tools;

    package data_base;
#------------------------------------------------------

    use vars qw($db $dbFile $dbDateHour $dbCarNumber);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# makeDb 
#------------------------------------------------------
    sub makeDb {
        my ($db)=@_;

        $db->do("CREATE TABLE log (
        run_number INTEGER, 
        car_number INTEGER ,
        date_time  TEXT,
        data BLOB
        );");

        $db->do("CREATE INDEX i001
        ON log ( run_number, car_number) ;");

        $db->do("CREATE INDEX i002
        ON log ( date_time) ;");

        return;
    }
#------------------------------------------------------
# openDataBase
#------------------------------------------------------
    sub openDataBase {
        my ($dateHour)=@_;


        if ($dbDateHour ne "")
        {
            $db->disconnect();
        }


        $dbFile="database/${parameters::point_code}_$dateHour.SQLite";

        my $res=openDataBaseFile($dbFile);

        unless ($res)
        {
            print "REINDEX fall;recreate database;\n";
            $db->disconnect();
            unlink($dbFile); 
            openDataBaseFile($dbFile);
        }

        $dbDateHour=$dateHour;

        return;
    }
#------------------------------------------------------
# openDataBaseFile
#------------------------------------------------------
    sub openDataBaseFile {
        my ($dbFile)=@_;

        my $res=1;

        $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";
        if (-z $dbFile)
        {
            makeDb($db);
        }else
        {

            print "REINDEX...\n";
            $res=$db->do("REINDEX;");

        }

        return $res;
    }
#------------------------------------------------------
# lastDataFile
#------------------------------------------------------
    sub lastDataFile {

        my $list=mashine_tools::dirList("database");

    #    print ::dump($list),"\n";

        @$list = grep(m{\.SQLite$}is, @$list);

    #    print ::dump($list),"\n";

        @$list=sort(@$list);

    #    print ::dump($list),"\n";

        my $lastFile1=pop @$list;

        my ($point_code,$dateHour)=($lastFile1 =~ m{^(.{8})_(.{10})}s);
#        my $baseName=substr($lastFile1,0,19);

        return $dateHour;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        $dbDateHour="";
        $dbCarNumber=0;

        my $dateHour=lastDataFile();
        openDataBase($dateHour) if $dateHour;

        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($pribor,$data)=@_;

#       push(@res,[$num,$chenel,$dirct,$timeL,$lenght,$speed]);

        my ($num,$chenel,$time,$lenght,$speed)=unpack("CCLSC",$data); # len=9

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        $chenel += $pribor->{chanel};

        my $timeSec=$time/1000+$pribor->{pr_baseTime};

        $data .= pack("LLL",$timeSec,$parameters::run_number,$dbCarNumber);  # len=12

        my $timeL=fileLib::toSql($timeSec);

#           print "($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

        my $dateHour=substr($timeL,0,13);

        $dateHour =~ tr/\- //d;

        if ($dateHour ne $dbDateHour)
        {
            openDataBase($dateHour);
        };

        substr($data,1,1,pack("C",( $chenel | $dirct )));


        $db->do("INSERT INTO log 
        (run_number, car_number, date_time, data) 
        VALUES(?,?,?,?) ",{},
        ($parameters::run_number,$dbCarNumber,$timeL,$data)
        );

#        print "DB>";tranfer::printData($data);

        print "$dateHour-($parameters::run_number,$dbCarNumber,$pribor->{pr_adress})($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

        $dbCarNumber++;


        return;
    }
#------------------------------------------------------
1;
