#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use tranfer;
    use pribor;
    use read_pass;
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

   pribor::init(0x10);

   pribor::readyUp();

   pribor::syncTime();

   while(1)
   {
      read_pass::readCars();
   }

   tranfer::closePort();

}
#------------------------------------------------------
$|++;
main(@ARGV);
