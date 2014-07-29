#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use tranfer;
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

   tranfer::openPort();
   tranfer::sendData("\x01\x10\x01");

   my $data=tranfer::readData();

   tranfer::closePort();

}
#------------------------------------------------------
$|++;
main(@ARGV);
