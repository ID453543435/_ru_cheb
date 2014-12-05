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
# main
#------------------------------------------------------
sub main {

    $cgi = CGI->new; # create new CGI object
    print $cgi->header; # create the HTTP header

    my $point_id=$m_cgi::cgi->param('point_id');

    my $pointDir=$parameters::tempFileDir."settings/".sprintf("%08i/",$point_id);

    my $data   = fileLib::fileTostr($pointDir."send/settings.pl");

    print $data;


}
#------------------------------------------------------
#$|++;
main();
