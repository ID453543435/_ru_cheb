#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use file_db;
    use mashine_tools;
 
    package post_file;
    use Time::Local;
#------------------------------------------------------

    use vars qw($post_file_name $post_input_name $post_file_short);
    use vars qw($post_file_status);
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


        return;
    }
#------------------------------------------------------
# nextHour
#------------------------------------------------------
    sub nextHour {
        my ($dateHour)=@_;


        my ($year,$mon,$mday,$hour)=($dateHour =~ /(....)(..)(..)(..)/);

        my $time_gm=0+timegm(0,0,$hour,$mday,$mon-1,$year-1900);
        
        $time_gm += 60*60;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                            gmtime($time_gm);

        $dateHour=sprintf("%04i%02i%02i%02i",$year+1900,$mon+1,$mday,$hour);

        return $dateHour;
    }
#------------------------------------------------------
# makePreLast
#------------------------------------------------------
    sub makePreLast {
        my ($run_number_in, $car_number_in, $sqllite_file)=@_;
        
        my $db = mashine_tools::openDataBase($sqllite_file);
        
        my $request= "SELECT run_number, car_number, date_time, data
             FROM log WHERE run_number>? OR (run_number = ? AND car_number>?)
             ORDER BY run_number, car_number ;";

        ($post_file_name)=mashine_tools::saveSelectBin($db,$request,[$run_number_in, $run_number_in, $car_number_in],$post_file_short);
        
        $db->disconnect();

        return;
    }
#------------------------------------------------------
# makeLast
#------------------------------------------------------
    sub makeLast {
        my ($run_number_in, $car_number_in, $dateHour)=@_;


        my $request=<<"DATA";
run_number=$run_number_in
car_number=$car_number_in
dateHour=$dateHour
DATA
        my $fileName="temp/request";

        fileLib::strToFile($fileName,$request);

        while(-f $fileName)
        {
           sleep(1);
        }


        unless (-f ("temp/$dateHour"))
        {
            $post_file_status=301;
        }
        
        
        return;
    }
#------------------------------------------------------
# findFile
#------------------------------------------------------
    sub findFile {
        my ($run_number_in, $car_number_in, $dateTime_in)=@_;


        $post_file_status="";

        my $dateHour_in=mashine_tools::dateHour($dateTime_in);

        if ($dateHour_in lt $file_db::fistDateHour)
        {
           $dateHour_in=$file_db::fistDateHour;
        }

        print "post_file.pm:$dateHour_in=$file_db::fistDateHour=$file_db::lastDateHour=\n";

        my $dateHour=$dateHour_in;


        my ($file,$baseName,$run_number, $car_number,$point_code)=file_db::fileData($dateHour);

        if ($run_number_in<$run_number)
        {
        } elsif ($car_number_in<$car_number)
        {
        } else
        {
            while(1)
            {
                print "($dateHour le ${file_db::lastDateHour})\n";
                last if ($dateHour ge $file_db::lastDateHour);

                $dateHour=nextHour($dateHour);
                ($file,$baseName,$run_number, $car_number,$point_code)=file_db::fileData($dateHour);
                last if $file;
            }
        }

        my $sqllite_file="database/$baseName.SQLite";

        if ($run_number ne "")
        {
            if (-f($sqllite_file) and ($dateHour_in eq $dateHour))
            {

                $post_file_short=$baseName;
                $post_input_name="data";

                makePreLast($run_number_in, $car_number_in, $sqllite_file);
                $post_file_status=201;

            }else
            {
                $post_file_name="archives/$file";
                $post_file_short=$file;
                $post_input_name="data_arx";
                $post_file_status=203;
            }
        }
        else
        {
            $post_file_name="temp/$dateHour";
            $post_file_short=$dateHour;
            $post_input_name="data";
            $post_file_status=200;

            makeLast($run_number_in, $car_number_in, $dateHour);
        }

        return;
    }
#------------------------------------------------------
# deleteFile
#------------------------------------------------------
    sub deleteFile {

        if ($post_input_name eq "data")
        {
            unlink($post_file_name) or die;
        }

        return;
    }
#------------------------------------------------------
1;
