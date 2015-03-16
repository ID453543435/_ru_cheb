#!perl.exe
#------------------------------------------------------
=head1 NAME
base
=head1 SYNOPSIS

=cut
#------------------------------------------------------
     use strict;
     use parameters;
     use m_cgi;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# settingsStatus
#------------------------------------------------------
sub settingsStatus {
    my ($point_id)=@_;

    my $pointDir=$parameters::tempFileDir."settings/".sprintf("%08i/",$point_id);

    my $currentDir=$pointDir."current/";
    my $sendDir=$pointDir."send/";

    mkdir($pointDir);
    mkdir($currentDir);
    mkdir($sendDir);


    return "set" if (-f ($sendDir."settings.pl"));
    return "get" unless (-f ($currentDir."settings.pl"));

    return "";
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    m_cgi::init();
    m_cgi::connectDB();

    my $point_id=$m_cgi::cgi->param('point_id');


    my ($status) = m_cgi::SQLrow(
        "SELECT status
         FROM points
         WHERE id=?;",[$point_id]);


    my ($run_number,$car_number,$date_time) = m_cgi::SQLrow(
        "SELECT runnumber,carnumber,datetime
         FROM data
         WHERE pointid=?
         ORDER BY pointid DESC, runnumber DESC, carnumber DESC LIMIT 1;",[$point_id]);
    

    print "status=$status\n";
    print "point_id=".sprintf("%08i",$point_id)."\n";
    print "run_number=".sprintf("%08i",$run_number)."\n";
    print "car_number=".sprintf("%08i",$car_number)."\n";
    print "date_time=".$date_time."\n";

    print "settings_order=".settingsStatus($point_id)."\n";

    print "<!---end--->\n";
    
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
