#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use Win32::SerialPort;
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
                                       
  my $PortName="COM3";
  my $quiet=0;

  my $PortObj = new Win32::SerialPort ($PortName, $quiet)
       || die "Can't open $PortName: $^E\n";    # $quiet is optional

  $PortObj->user_msg("ON");
  $PortObj->databits(8);
  $PortObj->baudrate(115200);
  $PortObj->parity("none");
  $PortObj->stopbits(1);
  $PortObj->handshake("rts");
  $PortObj->buffers(4096, 4096);

  $PortObj->write_settings || undef $PortObj;

  print "write_settings OK\n";


#  $PortObj->save($Configuration_File_Name);

#  $PortObj->baudrate(300);
#  $PortObj->restart($Configuration_File_Name);  # back to 9600 baud

  my $data = pack("W",0x7E).pack("W5",0x01,0x10,0x01,0x00,0xEC).pack("W",0x7E);

  $PortObj->error_msg(1);  # prints hardware messages like "Framing Error"
  $PortObj->user_msg(1);   # prints function messages like "Waiting for CTS"


  my $count_out = $PortObj->write($data);
  warn "write failed\n"         unless ($count_out);
  warn "write incomplete\n"     if ( $count_out != length($data) );  

  my $InBytes=1;
  my ($count_in, $string_in);
  while (1)
  {
     ($count_in, $string_in) = $PortObj->read($InBytes);
#     warn "read unsuccessful\n" unless ($count_in == $InBytes);
#     last unless ($count_in == $InBytes);
     next unless $string_in;
     print unpack("W",$string_in),"\n";
  }
  
  $PortObj->close || die "failed to close";
  undef $PortObj;   
}
#------------------------------------------------------
$|++;
main(@ARGV);
