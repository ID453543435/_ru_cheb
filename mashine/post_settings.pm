#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
 
    use LWP::UserAgent;
    use LWP;
    use HTML::Form;
    use HTTP::Request::Common;

    use mashine_tools;

    package post_settings;
#------------------------------------------------------

#    use vars qw(%files);
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

        $HTTP::Request::Common::DYNAMIC_FILE_UPLOAD = 1;

        return;
    }
#------------------------------------------------------
# post
#------------------------------------------------------
    sub post {

        print "post_settings::post()";

        my $ua = new LWP::UserAgent;
#        $ua->timeout(6);
        
        my $settingsFile="settings/settings.pl";

        my %form=(
        submit=>"Отправить",
        point_id=>$parameters::point_code,
        data=>[$settingsFile],
        );

        my $req=HTTP::Request::Common::POST("${parameters::server_url}post_settings.pl", \%form, Content_Type => "multipart/form-data");

        my $res = $ua->request($req);

        my ($head,$body);
        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
           print "$head\n";
           return(301);
        }

        print $body;

        return($res->code);
    }
#------------------------------------------------------
# get
#------------------------------------------------------
    sub get {

        print "post_settings::get()";

        my $ua = new LWP::UserAgent;
#        $ua->timeout(6);

        my $req = new HTTP::Request GET => "${parameters::server_url}get_settings.pl?point_id=${parameters::point_code}";

        my $res = $ua->request($req);

        my ($head,$body);
        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
           return(302);
        }

        print $body;


        return($res->code);
    }
#------------------------------------------------------
# handle
#------------------------------------------------------
    sub handle {
        my ($params)=@_;


        if ($$params{settings_order} eq "get")
        {
            return post();
        }
        if ($$params{settings_order} eq "set")
        {
            return get();
        }
        


        return;
    }
#------------------------------------------------------
1;
