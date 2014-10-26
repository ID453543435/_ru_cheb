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
        $self->{buffer} = "";

        return $self;
    }
#------------------------------------------------------
# readyUp
#------------------------------------------------------
    sub readyUp {
        my $self = shift;

        
        sendData($self,"FFAAC00200010001");
#        sendData($self,"FFAAC00200020002");
        sendData($self,"FFAA53030001000001");
        sendData($self,"FFAA540200010001");
#        sendData($self,"FFAA53030001000001");


        pingPribor($self);


        return;
    }
#------------------------------------------------------
# pingPribor
#------------------------------------------------------
    sub pingPribor {
        my $self = shift;


        my $tTime=time();

        if ($tTime - $self->{pr_baseTime} > 36)
        {
            sendData($self,"FFAA53030001000001");

            $self->{pr_baseTime}=$tTime;
        }

        return;
    }
#------------------------------------------------------
# syncTime
#------------------------------------------------------
    sub syncTime {
        my $self = shift;


        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my $self = shift;
        my ($str)=@_;

        my $data=pack( 'H*',$str);

        tranfer::sendData($data);

        return;
    }
#------------------------------------------------------
# takeFromBufer
#------------------------------------------------------
    sub takeFromBufer {
        my $self = shift;

        my $ind=index($self->{buffer},"\xFF\xAA");

        return "" if $ind<0;

        if ($ind>0)
        {
            my $data=substr($self->{buffer},0,$ind,"");

            return "";

        }

        return "" if length($self->{buffer}) < 6;

#        $ind=index($self->{buffer},"\xFF\xAA",2);

        my $length=unpack("S",substr($self->{buffer},3,2))+6;

        

        if ($length <= length($self->{buffer}))
        {
            my $data=substr($self->{buffer},0,$length,"");

            return($data);

        }

        return "";
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {
        my $self = shift;

        $self->{buffer} .= com_port::readData(2048);

        return;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {
        my $self = shift;


        readData($self);

        my $num=-1;
        my @res=();
        while(1)
        {

           my $data=takeFromBufer($self);
           last unless $data;

           pingPribor($self);

           $data=filter($data);
           next unless $data;

           $num++;

           print ">";tranfer::printData($data);
           

#           push(@res,$car);
        }
        if ( $num != -1)
        {
        }


        return \@res;
    }
#------------------------------------------------------
# filter
#------------------------------------------------------
    sub filter {
        my ($data)=@_;


        my $type=unpack("C",substr($data,2,1));

        if ($type >= 0x10 and $type <= 0x18)
        {
            return $data;
        }

        return;
    }
#------------------------------------------------------
1;
