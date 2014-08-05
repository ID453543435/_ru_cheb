#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
 
    use LWP::UserAgent;
    use LWP;

    package post_data;
    use file_db;
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
# findFile
#------------------------------------------------------
    sub findFile {
        my ($run_number, $car_number, $dateTime)=@_;


        return $par;
    }
#------------------------------------------------------
# post
#------------------------------------------------------
    sub post {

        my $ua = new LWP::UserAgent;
#        $ua->timeout(6);
        
        $req = new HTTP::Request GET => "${parameters::server_url}post_form.pl?point_id=${parameters::point_code}";

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


        my $postFile=findFile($$params{run_number},$$params{$car_number},$$params{$date_time});

        
        my @forms = HTML::Form->parse( $body, "${parameters::server_url}post_form.pl" );

        my $form=$forms[0];

        $form->param("point_id",$parameters::point_code) ;

        my $input_file = $form->find_input( "data_arx" ) ;

        $input_file->filename( $postFile );
        $input_file->content( fileLib::fileToStr($postFile) ); 

        $req=$form->click();

        
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
