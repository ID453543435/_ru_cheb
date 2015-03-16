#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Time::Local;
    use strict;
    use tranfer;
#------------------------------------------------------
    package pribor;

#    use vars qw($pr_adress $pr_packet $pr_baseTime);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# new
#------------------------------------------------------
    sub new {
        my ($class,$adress)=@_;

        my $self  = {};
        bless($self, $class);
        
        $self->{pr_packet} = -1;
        $self->{pr_adress} = $adress;
        $self->{pr_baseTime} = "";

        return $self;
    }
#------------------------------------------------------
# readyUp
#------------------------------------------------------
    sub readyUp {
        my $self = shift;

        sleep(1);

        while (1)
        {
           pribor::sendData($self,"\x01"); #Эхо-запрос

           my $data=pribor::readData($self);

           last if $data eq "\x00";
           last if $data eq "\x01";
           last if $data eq "\x02";
           last if $data eq "\x03";

           sleep(1);
        }

        return;
    }
#------------------------------------------------------
# syncTime
#------------------------------------------------------
    sub syncTime {
        my $self = shift;

        pribor::sendData($self,"\x02"); #Синхронизация
        $self->{pr_baseTime}=time();
        sleep(0.1);

        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my $self = shift;
        my ($data)=@_;

        $self->{pr_packet}++;

        $self->{pr_packet} = $self->{pr_packet} & 0xFF;


        $data=pack("CC",$self->{pr_packet},$self->{pr_adress}).$data;

        tranfer::sendData($data);


        printf("%02x:%02x\r",$self->{pr_adress},$self->{pr_packet});

        return;
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {
        my $self = shift;

        my ($data,$packet,$adress);
        while(1)
        {
           $data=tranfer::readData($self);

           last unless $data;

           ($packet,$adress)=unpack("CC",$data);

           last if $packet == $self->{pr_packet};
        }
        $data=substr($data,2);


        return $data;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {
        my $self = shift;


        sendData($self,"\x05"); #Чтение буфера событий
        my $data=readData($self);

        my $num=-1;
        my @res=();
        while(1)
        {
           last if substr($data,0,2) eq "\xff";
           last if length($data) < 9;

           my $car=substr($data,0,9);

           ($num)=unpack("C",$car);
          
           push(@res,$car);
           
           $data=substr($data,9);
        }
        if ( $num != -1)
        {
           pribor::sendData($self,"\x06".pack("C",$num));
           my $data=pribor::readData($self);
        }


        return \@res;
    }
#------------------------------------------------------
1;
