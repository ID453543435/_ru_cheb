#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use tranfer;
#------------------------------------------------------
    package pribor;

    use vars qw($pr_adress $pr_packet);
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
# sendData
#------------------------------------------------------
    sub sendData {
        my ($data)=@_;

        $pr_packet++;

        $data=pack("cc",$pr_packet,$pr_adress).$data;

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
           $data=readPacket();

           ($packet,$adress)=unpack("cc",$data);

           last if $packet == $pr_packet;
        }
        $data=substr($data,2);


        return $data;
    }
#------------------------------------------------------
1;
