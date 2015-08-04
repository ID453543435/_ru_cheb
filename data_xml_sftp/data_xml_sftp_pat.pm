#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);
    use File::Copy;
    
    use strict;

    package data_xml_sftp;
#------------------------------------------------------

#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# data_init
#------------------------------------------------------
    sub data_init {
        my ($time)=@_;

        %data=();
        $timeFrom=$time;

        return;
    }
#------------------------------------------------------
# data_saveFile
#------------------------------------------------------
    sub data_saveFile {

#        print ::dump(\%data),"\n";

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
                       lane=>$chanel+1,
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
        my $outfile="${parameters::data_xml_sftp_send_point_id}_".toFile($timeFrom)."_".int(rand(100000)).".xml";

#        print "$outfile:\n",
        XMLout({id=>$parameters::data_xml_sftp_send_point_id, datetime => toISO($timeFrom) , 
        data =>\@data 
        },  keyattr    => {  }, RootName => 'report'
        , OutputFile => "temp/temp_xml.xml"
        );


        ::move("temp/temp_xml.xml","data_xml/$outfile") or die;


        return;
    }
#------------------------------------------------------
# data_saveData
#------------------------------------------------------
    sub data_saveData {
        my ($num,$dirct,$chenel,$timeSec,$lenght,$speed)=@_;

        $lenght=$lenght/64;

        my $class=car_class::giveClass($lenght);

        my $directtion= $dirct ? "forward" : "backward";

#        print "($chenel,$directtion,$class,$speed,$timeSec)\n";

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
