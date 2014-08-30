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

    use vars qw($pr_adress $pr_packet $pr_baseTime);
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
        my ($adress)=@_;

        $pr_packet=-1;
        $pr_adress=$adress;


        return;
    }
#------------------------------------------------------
# readyUp
#------------------------------------------------------
    sub readyUp {

        sleep(1);

        while (1)
        {
           pribor::sendData("\x01"); #Эхо-запрос

           my $data=pribor::readData();

           last if $data eq "\x00";
           last if $data eq "\x01";

           sleep(1);
        }

        return;
    }
#------------------------------------------------------
# syncTime
#------------------------------------------------------
    sub syncTime {

        pribor::sendData("\x02"); #Синхронизация
        $pr_baseTime=time();

        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my ($data)=@_;

        $pr_packet++;

        $pr_packet = $pr_packet & 0xFF;


        $data=pack("CC",$pr_packet,$pr_adress).$data;

        tranfer::sendData($data);


        printf("%02x\r",$pr_packet);

        return;
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {

        my ($data,$packet,$adress);
        while(1)
        {
           $data=tranfer::readData();

           last unless $data;

           ($packet,$adress)=unpack("CC",$data);

           last if $packet == $pr_packet;
        }
        $data=substr($data,2);


        return $data;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {


        sendData("\x05"); #Чтение буфера событий
        my $data=readData();

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
           pribor::sendData("\x06".pack("C",$num));
           my $data=pribor::readData();
        }


        return \@res;
    }
#------------------------------------------------------
1;
