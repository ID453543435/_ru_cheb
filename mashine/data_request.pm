#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use DBI;
    use strict;
    use fileLib;
    use mashine_tools;

    package data_request;
#------------------------------------------------------

    use vars qw($fileName);

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

        $fileName="temp/request";

        unlink($fileName);

        return;
    }
#------------------------------------------------------
# checkRequest
#------------------------------------------------------
    sub checkRequest {

        return unless -f $fileName;

        my $req=mashine_tools::strToHASH(fileLib::fileToStr($fileName));

#        my $postFile=post_file::findFile($$params{run_number},$$params{car_number},$$params{date_time});
#        my $dateHour=mashine_tools::dateHour($$req{date_time});
        my $dateHour=$$req{dateHour};

        if ($dateHour eq $data_base::dbDateHour)
        {
            my $request= "SELECT run_number, car_number, date_time, data
                 FROM log WHERE run_number>? OR (run_number = ? AND car_number>?)
                 ORDER BY run_number, car_number ;";

            mashine_tools::saveSelectBin($data_base::db, $request
            ,[$$req{run_number}, $$req{run_number}, $$req{car_number}]
            ,$dateHour);
        }
        unlink($fileName) or die;

        return;
    }
#------------------------------------------------------
1;
