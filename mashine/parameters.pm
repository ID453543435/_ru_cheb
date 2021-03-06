#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use LWP::UserAgent;
    use LWP;
    use HTTP::Request::Common;

    use strict;
    use fileLib;
    use mashine_tools;

    package parameters;
#------------------------------------------------------

    use vars qw($point_code $run_number $server_url);
    use vars qw($com_port $com_port_adres $com_port_port);
    use vars qw($com_port_linux_file $com_port_speed);
    use vars qw($pribor @dev_adress);

    use vars qw($data_xml_sftp_enable);
    use vars qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    use vars qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);
    
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# getNewPointCodeSub
#------------------------------------------------------
    sub getNewPointCodeSub {
    
        my $ua = new LWP::UserAgent;
#        $ua->timeout(6);
        
        my $req = new HTTP::Request GET => "${parameters::server_url}new_point.pl";

        my $res = $ua->request($req);

        my ($head,$body);
        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
           return("");
        }

        my $params=mashine_tools::parseHTML($body);

        return $$params{num};
    }
#------------------------------------------------------
# getNewPointCode
#------------------------------------------------------
    sub getNewPointCode {

        while(1)
        {
            my $num=getNewPointCodeSub();
            return($num) if $num;
        }
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        do "settings_base.pl";
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
# initPost
#------------------------------------------------------
    sub initPost {

        do "settings_base.pl";
        do "settings/settings.pl";

        my $fileName="settings/run_number";
        $run_number=fileLib::fileToStr($fileName);

        $fileName="settings/point_code";
        $point_code=fileLib::fileToStr($fileName);

        return;
    }
#------------------------------------------------------
1;
