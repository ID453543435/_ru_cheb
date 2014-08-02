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

    my $point_id=$m_cgi::cgi->param('point_id');

    my $sth = $m_cgi::db->prepare(
        "SELECT run_number,car_number,date_time
         FROM data
         WHERE point_id=?
         ORDER BY point_id,run_number,car_number DESC LIMIT 1;");
    
    $sth->execute($point_id) or die $DBI::errstr;

    print "Number of rows found :" . $sth->rows . "\n";

    my ($run_number,$car_number,$date_time);
    while (my @row = $sth->fetchrow_array()) {
       ($run_number,$car_number,$date_time) = @row;
    }
    $sth->finish();    


    print "point_id=".sprintf("%08i",$point_id)."\n";
    print "run_number=".sprintf("%08i",$run_number)."\n";
    print "car_number=".sprintf("%08i",$car_number)."\n";
    print "date_time=".$date_time."\n";

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
