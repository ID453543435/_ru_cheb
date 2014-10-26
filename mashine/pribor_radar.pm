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

    use vars qw(@classes);


    @classes = (3,7.5,10,12,17.5,23);


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
        $self->{packet} = [];

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

        if ($tTime - $self->{pr_baseTime} > 3)
        {
            sendData($self,"FFAA53030001000001");

            $self->{pr_baseTime}=$tTime;

#            print "ping\n";
        }

        return;
    }
#------------------------------------------------------
# syncTime
#------------------------------------------------------
    sub syncTime {
        my $self = shift;

        $self->{pr_baseTime}=time();

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

#           pingPribor($self);

           my $type=filter($data);
           next unless $type;

           $num++;

           print ">";tranfer::printData($data);


           $self->{packet}->[$type - 0x10 ]=$data;


           if ($type == 0x18)
           {
                emulateCars($self,\@res);
           }

        }
        if ( $num != -1)
        {
        }


        return \@res;
    }
#------------------------------------------------------
# getNumbers
#------------------------------------------------------
    sub getNumbers {
        my ($str)=@_;


        my $data=substr($str,6,-2);

        my @res=unpack("n*",$data);


        return \@res;
    }
#------------------------------------------------------
# encodeCar
#------------------------------------------------------
    sub encodeCar {
        my $self = shift;
        my ($res,$chenel,$class,$speed,$num)=@_;


        my $leng=$classes[$class];

        print "($chenel,$leng($class),$speed,$num)\n" if $num;

        my $data=pack("CCLSC",0,$chenel,(time() - $self->{pr_baseTime})*1000,$leng*16,$speed);
        for (my $i=0;$i<$num;$i++)
        {
            push(@$res,$data);
        }
        

        return;
    }
#------------------------------------------------------
# emulateCars
#------------------------------------------------------
    sub emulateCars {
        my $self = shift;
        my ($res)=@_;


        my $itog=getNumbers($self->{packet}->[0]);
        my $speed=getNumbers($self->{packet}->[2]);


        for (my $i=4;$i<=8;$i++)
        {

             my $class=getNumbers($self->{packet}->[$i]);

             for (my $j=0;$j<@$class;$j++)
             {
                 $$itog[$j] -= $$class[$j];

                 encodeCar($self,$res,$j,$i-3,$$speed[$j],$$class[$j]);
             }
        }

        for (my $j=0;$j<@$itog;$j++)
        {
            encodeCar($self,$res,$j,0,$$speed[$j],$$itog[$j]);
        }

        return;
    }
#------------------------------------------------------
# filter
#------------------------------------------------------
    sub filter {
        my ($data)=@_;

        my $type=unpack("C",substr($data,2,1));

        print "[$type]\r";

        if ($type >= 0x10 and $type <= 0x18)
        {
            return $type;
        }

        return "";
    }
#------------------------------------------------------
1;
