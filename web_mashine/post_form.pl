#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME
base
=head1 SYNOPSIS

=cut
#------------------------------------------------------
     use strict;
     use m_cgi;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    m_cgi::init();
    m_cgi::connectDB();

    my $point_id=$m_cgi::cgi->param('text1');


    print $m_cgi::cgi->start_form(
        -name    => 'main_form',
        -method  => 'POST',
#        -enctype => &CGI::URL_ENCODED,
#        -onsubmit => 'return javascript:validation_function()',
        -action => 'data_send.pl', # Defaults to 
                                                 # the current program
    ),"\n";    

    print "point_id:";
    print $m_cgi::cgi->textfield(
        -name      => 'point_id',
        -value     => $point_id,
        -size      => 20,
        -maxlength => 30,
    ),"\n";

    print "data:";
    print $m_cgi::cgi->filefield(
        -name => 'data',
    ),"\n";

    print "data_arx:";
    print $m_cgi::cgi->filefield(
        -name => 'data_arx',
    ),"\n";    
    
    print $m_cgi::cgi->submit(
        -name     => 'submit_form',
        -value    => 'POST',
#        -onsubmit => 'javascript: validate_form()',
    ),"\n";

    print $m_cgi::cgi->end_form,"\n";


    $m_cgi::db->disconnect();
    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();
