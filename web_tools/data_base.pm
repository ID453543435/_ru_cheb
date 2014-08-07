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

    use vars qw($db);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        # MySQL database configurations
        my $dsn = "DBI:mysql:test";
        my $username = "root";
        my $password = '';

        # connect to MySQL database
        my %attr = (PrintError=>0, RaiseError=>1);

        my $db = DBI->connect($dsn,$username,$password, \%attr);

        return;
    }
#------------------------------------------------------
# disconnect
#------------------------------------------------------
    sub disconnect {

        # disconnect from the MySQL database
        $db->disconnect();

        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($point_id,$data)=@_;

        my ($num,$chenel,$time,$lenght,$speed,$timeSec,$run_number,$carNumber)=unpack("CCLSCLLL",$data);

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        my $timeL=fileLib::toSql($timeSec);

        $db->do("INSERT IGNORE INTO data 
        (point_id, run_number, car_number, date_time, data) 
        VALUES(?,?,?,?,?) ",{},
        ($point_id,$run_number,$carNumber,$timeL,$data)
        );

        print "($point_id,$run_number,$carNumber,$timeL,data)\n";

        return;
    }
#------------------------------------------------------
1;