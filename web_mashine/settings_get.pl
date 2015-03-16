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
     use fileLib;
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

    $m_cgi::cgi = CGI->new; # create new CGI object
    print $m_cgi::cgi->header; # create the HTTP header

    my $point_id=$m_cgi::cgi->param('point_id');

    my $pointDir=$parameters::tempFileDir."settings/".sprintf("%08i/",$point_id);

    my $settingsFile=$pointDir."send/settings.pl";

    my $data   = fileLib::fileToStr($settingsFile);

    print $data;

    unlink($settingsFile);


}
#------------------------------------------------------
#$|++;
main();
