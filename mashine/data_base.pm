#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use DBI;

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
        date_time  ,
        data
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
        $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";
        makeDb($db) if -z $dbFile;

        $dbDateHour=$dateHour;

        return;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        $dbDateHour="";
        $dbCarNumber=0;

        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($data)=@_;

#       push(@res,[$num,$chenel,$dirct,$timeL,$lenght,$speed]);

        my ($num,$chenel,$time,$lenght,$speed)=unpack("CCLSC",$data);

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        my $timeSec=$time/1000+$pribor::pr_baseTime;

        $data .= pack("L",$timeSec);

        my $timeL=fileLib::toSql($timeSec);

#           print "($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

        my $dateHour=substr($timeL,0,13);

        $dateHour =~ tr/\- //d;

        if ($dateHour ne $dbDateHour)
        {
            openDataBase($dateHour);
        };

        $db->do("INSERT INTO log 
        (run_number, car_number, date_time, data) 
        VALUES(?,?,?,?) ",{},
        ($parameters::run_number,$dbCarNumber,$timeL,$data)
        );
        

        print "$dateHour-($parameters::run_number,$dbCarNumber)($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

        $dbCarNumber++;


        return;
    }
#------------------------------------------------------
1;
