#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use pribor;
    use fileLib;
#------------------------------------------------------
    package read_pass;

#    use vars qw($comPort);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {


        pribor::sendData("\x05"); #Чтение буфера событий
        my $data=pribor::readData();

        my $num=-1;
        while(1)
        {
           last if substr($data,0,2) eq "\xff";

           my $car=substr($data,0,9);

           my ($chenel,$time,$lenght,$speed);
           ($num,$chenel,$time,$lenght,$speed)=unpack("CCLSC",$car);

           my $dirct=$chenel & 0xf0;

           $chenel=$chenel & 0x0f;

           my $timeL=fileLib::toSql($time/1000+$pribor::pr_baseTime);

           print "($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

           $data=substr($data,9);
           last unless $data;
        }
        if ( $num != -1)
        {
           pribor::sendData("\x06".pack("C",$num));
           my $data=pribor::readData();
        }


        return;
    }
#------------------------------------------------------
1;
