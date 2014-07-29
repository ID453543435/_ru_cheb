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

        $data=pack("CC",$pr_packet,$pr_adress).$data;

        tranfer::sendData($data);


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

           ($packet,$adress)=unpack("CC",$data);

           last if $packet == $pr_packet;
        }
        $data=substr($data,2);


        return $data;
    }
#------------------------------------------------------
1;
