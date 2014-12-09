#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);
    use File::Copy;
    
    use strict;
#    use fileLib;
    use car_class;

    package data_xml_sftp;

    use XML::Simple qw(:strict);
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
        
        os_spec::start("mashine_sync_sftp.pl");

        return;
    }
#------------------------------------------------------
# время в toISO формат из UNIX
#------------------------------------------------------
    sub toISO {
        my ($par)=@_;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                            gmtime($par);

        $year+=1900;
        $mon++;

        return sprintf("%04i%02i%02iT%02i%02i%02i+00",$year,$mon,$mday,$hour,$min,$sec);

    }
#------------------------------------------------------
# время в toFile формат из UNIX
#------------------------------------------------------
    sub toFile {
        my ($par)=@_;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                            gmtime($par);

        $year+=1900;
        $mon++;

        return sprintf("%04i%02i%02i%02i%02i%02i",$year,$mon,$mday,$hour,$min,$sec);

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


# =1000(V*t)/N (в метрах)
# V- Средняя скорость потока за период времени t
# t-период времени (в часах)
# N- количество машин за период времени t               
               my $periodHours=$parameters::data_xml_sftp_send_period/(60*60);
               $sensors{traffic_average_speed}=$sensors{speed}/$sensors{traffic_total_amount};
               $sensors{traffic_average_gap}=
               1000*($sensors{traffic_average_speed}*$periodHours)
               /$sensors{traffic_total_amount};
               $sensors{traffic_occupancy}=($sensors{traffic_total_amount}/$periodHours)/$parameters::data_xml_sftp_carpass_max[$chanel];
               $sensors{measure_period}=$parameters::data_xml_sftp_send_period/60;

               delete($sensors{speed});


               while (my ($sensor, $value) = each(%sensors)){

#                   next unless substr($sensor,0,8) eq "traffic_";

                   my %values=
                   (
                       line=>$chanel,
                       direction=>$directtion,
                       sensor=>$sensor,
                       value=>[$value]
                   );

                   push(@data,\%values);
               }
           }
        }
        %data=();


#EXTERNALID_YYYYMMDDHHiiss_RAND.xml,
        my $outfile="21${parameters::point_code}_".toFile($timeFrom)."_".int(rand(100000)).".xml";

#        print "$outfile:\n",
        XMLout({id=>$parameters::data_xml_sftp_send_point_id, datetime => toISO($timeFrom) , 
        data =>\@data 
        },  keyattr    => {  }, RootName => 'report'
        , OutputFile => "temp/temp_xml.xml"
        );


        move("temp/temp_xml.xml","data_xml/$outfile") or die;


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

#        my $chanDir=$data{$chenel}->{$directtion};

        $data{$chenel}->{$directtion}->{speed} += $speed;
        $data{$chenel}->{$directtion}->{traffic_total_amount}++;
        $data{$chenel}->{$directtion}->{"traffic_$class"}++;

#        (run_number, car_number, date_time, data) 
#        ($parameters::run_number,$dbCarNumber,$timeL,$data)


        return;
    }
#------------------------------------------------------
1;
