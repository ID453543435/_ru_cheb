#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use tranfer;
    use pribor;
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
#   tranfer::sendData("\x01\x10\x01");
   pribor::init(0x10);

   pribor::sendData("\x01"); #���-������

   my $data=tranfer::pribor();

   pribor::sendData("\x02"); #�������������

   pribor::sendData("\x05"); #������ ������ �������
   my $data=tranfer::pribor();

   tranfer::closePort();

}
#------------------------------------------------------
$|++;
main(@ARGV);
