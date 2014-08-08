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
             FROM log WHERE run_number>? AND car_number>?
             ORDER BY run_number, car_number ;";

        ($post_file_name)=mashine_tools::saveSelectBin($db,$request,[$run_number_in, $car_number_in],$post_file_short);
        
        $db->disconnect();

        return;
    }
#------------------------------------------------------
# makeLast
#------------------------------------------------------
    sub makeLast {
        my ($run_number_in, $car_number_in, $dateHour)=@_;

        
        return;
    }
#------------------------------------------------------
# findFile
#------------------------------------------------------
    sub findFile {
        my ($run_number_in, $car_number_in, $dateTime_in)=@_;


        $post_file_status="";

        my $dateHour=mashine_tools::dateHour($dateTime_in);

        if ($dateHour lt $file_db::fistDateHour)
        {
           $dateHour=$file_db::fistDateHour;
        }
        my $dateHour_in=$dateHour;


        my ($file,$baseName,$run_number, $car_number,$point_code)=file_db::fileData($dateHour);

        if ($run_number_in<$run_number)
        {
        } elsif ($run_number_in<$run_number)
        {
        } else
        {
            while(1)
            {
                $dateHour=nextHour($dateHour);
                ($file,$baseName,$run_number, $car_number,$point_code)=file_db::fileData($dateHour);
                last if $file;
                last if ($dateHour gt $file_db::lastDateHour);
            }
        }

        my $sqllite_file="";
        if ($dateHour_in eq $dateHour)
        {
             $sqllite_file="database/$baseName.SQLite";
        }


        if ($file)
        {
            if (-f($sqllite_file))
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
                $post_file_status=201;
            }
        }
        else
        {
            $post_file_name="temp/$baseName";
            $post_file_short=$baseName;
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
