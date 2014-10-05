#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use parameters;
    use data_base;
    use tranfer;
    use pribor;
    use read_pass;
    use data_request;
    use os_spec;
    use com_port;
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

   parameters::init();
   data_base::init();
   data_request::init();
   os_spec::init();
   com_port::init();

   tranfer::openPort();

   pribor::init(0x10);

   pribor::readyUp();

   pribor::syncTime();
   pribor::readCars();

   os_spec::start("mashine_sync.pl");

   while(1)
   {
      read_pass::readCars();
      data_request::checkRequest();
   }

   tranfer::closePort();

}
#------------------------------------------------------
$|++;
main(@ARGV);
