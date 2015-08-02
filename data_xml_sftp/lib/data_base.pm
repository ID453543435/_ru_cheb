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
        my $dsn = "DBI:mysql:mashine";
        my $username = "root";
        my $password = '';

        # connect to MySQL database
        my %attr = (PrintError=>1, RaiseError=>1);

        $db = DBI->connect($dsn,$username,$password, \%attr);

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
# printData
#------------------------------------------------------
    sub printData {
        my ($data)=@_;

        $data =~ s/(.)/sprintf("|%02x",ord($1))/esg; print "$data\n";
        
        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($point_id,$data)=@_;

#        printData($data);

        my ($num,$chenel,$time,$lenght,$speed,$timeSec,$run_number,$carNumber)=unpack("CCLSCLLL",$data);

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        my $timeL=fileLib::toSql($timeSec);

        my $err=0;
        if ($lenght>(64*50) or $speed>600)
        {
            $err++;
            $lenght=0;
            $speed=0;
        }


        $db->do("INSERT IGNORE INTO data 
        (pointid, runnumber, carnumber, datetime
        ,direct ,chenel ,lengh ,speed) 
        VALUES(?,?,?,?, ?,?,?,?) ",{},
        ($point_id,$run_number,$carNumber,$timeL
        ,$dirct,$chenel,$lenght,$speed)
        );

#        print "($point_id,$run_number,$carNumber,$timeL,data)\n";

        return $err;
    }
#------------------------------------------------------
# SQLrow
#------------------------------------------------------
    sub SQLrow {
        my ($request,$params)=@_;

        my $sth = $db->prepare($request);
        
        $sth->execute(@$params) or die $DBI::errstr;
#        print "Number of rows found :" . $sth->rows . "\n";

        my @res;
        while (my @row = $sth->fetchrow_array()) {
           @res=@row;
        }
        $sth->finish();    

        return @res;
    }
#------------------------------------------------------
1;
