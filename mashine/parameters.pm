#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;

    package parameters;
#------------------------------------------------------

    use vars qw($point_code $run_number);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# getNewPointCode
#------------------------------------------------------
    sub getNewPointCode {

        my $res=6;

        return $res;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        do "settings/settings.pl";

        my $fileName="settings/run_number";
        if (-f($fileName))
        {
             $run_number=fileLib::fileToStr($fileName);
             $run_number++;
        }
        else
        {
             $run_number=1;
        }
        fileLib::strToFile($fileName,$run_number);

        $fileName="settings/point_code";
        if (-f($fileName))
        {
             $point_code=fileLib::fileToStr($fileName);
        }
        else
        {
             $point_code=getNewPointCode();
             fileLib::strToFile($fileName,$point_code);
        }

        return;
    }
#------------------------------------------------------
1;
