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
    use pribor_list;
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


   pribor_list::init();
#   print join(";",@pribor_list::pribor_list),";\n";

#   my $pribor=new pribor(0x10);
#   pribor::init(0x10);

   pribor_list::readyUp();

   pribor_list::syncTime();
   pribor_list::readCars();

   os_spec::start("mashine_sync.pl");

   if ($parameters::data_xml_sftp_enable)
   {
      do "data_xml_sftp.pm";
      data_xml_sftp::init();
   }


   while(1)
   {
      for my $pribor (@pribor_list::pribor_list)
      {
          read_pass::readCars($pribor);
      }
      data_request::checkRequest();
      data_xml_sftp::saveFile(time()) if $parameters::data_xml_sftp_enable;
   }

   tranfer::closePort();

}
#------------------------------------------------------
$|++;
main(@ARGV);
