#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);

    use strict;
#    use fileLib;
    use car_class;

    package data_xml_sftp;

#    use XML::Simple qw(:strict);
#------------------------------------------------------

    use vars qw(%data $timeFrom);
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

        %data=();
        $timeFrom=time();

        return;
    }
#------------------------------------------------------
# saveFile
#------------------------------------------------------
    sub saveFile {
        my ($time)=@_;

        if ($time < ($parameters::data_xml_sftp_send_period + $timeFrom))
        {
            return;
        }
        $timeFrom +=$parameters::data_xml_sftp_send_period;

        print ::dump(\%data),"\n";


        my @data=();

        while (my ($chanel, $i) = each(%data)){
           while (my ($directtion, $j) = each(%$i)){

               my %sensors=%$j;


               while (my ($sensor, $value) = each(%sensors)){

                   my %values=
                   (
                       line=>$chanel,
                       direction=>$directtion,
                       sensor=>$sensor,
                       value=>[$value]
                   )

                   push(@data,\%values);
               }
           }
        }
        %data=();

        print XMLout({id=>"301", datetime => '20130731T093043+03' , 
        data =>\@data 
        },  keyattr    => {  }, RootName => 'report');


        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($pribor,$data)=@_;

#       push(@res,[$num,$chenel,$dirct,$timeL,$lenght,$speed]);

        my ($num,$chenel,$time,$lenght,$speed)=unpack("CCLSC",$data); # len=9

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        $chenel += $pribor->{chanel};

        my $timeSec=$time/1000+$pribor->{pr_baseTime};

#        my $timeL=fileLib::toSql($timeSec);

#           print "($num,$chenel,$dirct,$timeL,$lenght,$speed)\n";

#        substr($data,1,1,pack("C",( $chenel | $dirct )));

        $lenght=$lenght/16;

        my $class=car_class::giveClass($lenght);

        my $directtion= $dirct ? "forward" : "backward";

        print "($chenel,$directtion,$class,$speed,$timeSec)\n";

        my $chanDir=$data{$chenel}->{$directtion};

        $chanDir->{speed} += $speed;
        $chanDir->{total_amount}++;
        $chanDir->{$class}++;

#        (run_number, car_number, date_time, data) 
#        ($parameters::run_number,$dbCarNumber,$timeL,$data)


        return;
    }
#------------------------------------------------------
1;
