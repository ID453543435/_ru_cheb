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

    use vars qw($db $dbFile);
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
# init
#------------------------------------------------------
    sub init {

        $dbFile="database/dbfile.SQLite";
        $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";
        makeDb($db) if -z $dbFile;

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

        print "$dateHour-($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";


        return;
    }
#------------------------------------------------------
1;
