#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use pribor;
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

        while(1)
        {

           my $car=substr($data,0,9);

           my ($num,$chenel,$time,$lenght,$speed)=unpack("CCLSC",$car);

           my $dirct=$chenel & 0xf0;

           $chenel=$chenel & 0x0f;

           print "($num,$chenel,$dirct,$time,$lenght,$speed)\n";

           $data=substr($data,9);
           last unless $data;
        }


        return;
    }
#------------------------------------------------------
1;
