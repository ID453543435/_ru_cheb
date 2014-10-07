#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use IO::Socket::INET;
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
                                       
  my $PortObj = new IO::Socket::INET (
       PeerAddr => "192.168.1.60",
       PeerPort => 503,
       Proto => 'tcp',
  ) or die "ERROR in Socket Creation : $!\n";

  binmode($PortObj);

  print "write_settings OK\n";


#  $PortObj->save($Configuration_File_Name);

#  $PortObj->baudrate(300);
#  $PortObj->restart($Configuration_File_Name);  # back to 9600 baud

  my $data = pack("W",0x7E).pack("W5",0x01,0x10,0x01,0x00,0xEC).pack("W",0x7E);


  my $count_out = $PortObj->syswrite($data);
  print $count_out,"=",length($data),"\n";
  warn "write failed\n"         unless ($count_out);
  warn "write incomplete\n"     if ( $count_out != length($data) );  

  sleep(1);print "sleep(1)\n";

  my $InBytes=1;
  my ($count_in, $string_in);
  while (1)
  {
#     ($count_in, $string_in) = $PortObj->read($InBytes);
     $string_in="";
     $count_in = $PortObj->read($string_in,$InBytes);
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
