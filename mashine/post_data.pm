#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
 
    use LWP::UserAgent;
    use LWP;

    package post_data;
    use post_file;
#    use file_db;
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


        return;
    }
#------------------------------------------------------
# parseHTML
#------------------------------------------------------
    sub parseHTML {
        my ($str)=@_;

        my %res=();

        die "ERR=<www.worldsex.com> bad load 0\n" 
        if not ($str =~ m{<!---beg--->}gi);
        my $fromPoz=pos($str);
        die "ERR=<www.worldsex.com> bad load 1\n" 
        if not ($str =~ m{<!---end--->}gi);
        my $toPoz=pos($str);
        
        $str=substr($str,$fromPoz,$toPoz-$fromPoz);

        while ( $str =~ m{^(\w+)=(.*)$}gi ) 
        {
          $res{$1}=$2;
        }
        
        return \%res;
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

        my $params=parseHTML($body);


        my $postFile=post_file::findFile($$params{run_number},$$params{car_number},$$params{date_time});

        
        my @forms = HTML::Form->parse( $body, "${parameters::server_url}post_form.pl" );

        my $form=$forms[0];

        $form->param("point_id",$parameters::point_code) ;

        my $input_file = $form->find_input( $post_file::post_input_name ) ;

        $input_file->filename( $post_file::post_file_short );
        $input_file->content( fileLib::fileToStr($post_file::post_file_name) ); 

        $req=$form->click();

        post_file::deleteFile();
        
        my $res = $ua->request($req);

        if ($res->is_success) {
           $head=$res->headers_as_string;
           $body=$res->content;

        } else {
           $head="fall=".$res->code."=".$res->message;
           $body="";
           return(302);
        }


        return;
    }
#------------------------------------------------------
1;
