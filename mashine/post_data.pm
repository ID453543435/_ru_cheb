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

    use post_file;
    use mashine_tools;

    package post_data;
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

        my $ua = new LWP::UserAgent;
#        $ua->timeout(6);
        
        my $req = new HTTP::Request GET => "${parameters::server_url}post_form.pl?point_id=${parameters::point_code}";

        my $res = $ua->request($req);

        my ($head,$body);
        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
           return(301);
        }

        my $params=mashine_tools::parseHTML($body);


        if ($$params{status} != 0)
        {
#            print $body;
            return(401);
        }


        my $postFile=post_file::findFile($$params{run_number},$$params{car_number},$$params{date_time});

        if ($post_file::post_file_status == 301)
        {

            return(501);
        }

        
        my @forms = HTML::Form->parse( $body, "${parameters::server_url}post_form.pl" );

        my $form=$forms[0];

        $form->param("point_id",$parameters::point_code) ;

        my $input_file = $form->find_input( $post_file::post_input_name ) ;

#        $input_file->filename( $post_file::post_file_short );
#        $input_file->content( fileLib::fileToStr($post_file::post_file_name) ); 

        $input_file->file( $post_file::post_file_name );
        $input_file->filename( $post_file::post_file_short );

        $req=$form->click();

        my $res = $ua->request($req);
        post_file::deleteFile();

        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
#           print "$head\n";
           return(302);
        }

#        print $body;

        return($post_file::post_file_status);
    }
#------------------------------------------------------
1;
