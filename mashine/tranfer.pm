#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Win32::SerialPort;
    use strict;
    use rtu;
#------------------------------------------------------
    package tranfer;

    use vars qw($comPort);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# printData
#------------------------------------------------------
    sub printData {
        my ($data)=@_;

        $data =~ s/(.)/sprintf("|%02x",ord($1))/eg; print "$data\n";
        
        return;
    }
#------------------------------------------------------
# openPort
#------------------------------------------------------
    sub openPort {
        
        my $PortName="COM3";
        my $quiet=0;

        $comPort = new Win32::SerialPort ($PortName, $quiet)
             || die "Can't open $PortName: $^E\n";    # $quiet is optional

        $comPort->user_msg("ON");
        $comPort->databits(8);
        $comPort->baudrate(115200);
        $comPort->parity("none");
        $comPort->stopbits(1);
        $comPort->handshake("rts");
        $comPort->buffers(4096, 4096);

        $comPort->write_settings
             || die "Can't write_settings $PortName: $^E\n";

        return;
    }
#------------------------------------------------------
# closePort
#------------------------------------------------------
    sub closePort {

        $comPort->close || die "failed to close";

        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my ($data)=@_;

        print ">";printData($data);

        my $crc16=rtu::crc($data);
        $data=$data.pack("n",$crc16);

        $data =~ s{\x7E}{\x7D\x5E}g; 
        $data =~ s{\x7D}{\x7D\x5D}g; 

        $data = "\x7E".$data."\x7E";

#        $data =~ s/(.)/sprintf("|%02x",ord($1))/eg; print "$data\n";die;

        my $count_out = $comPort->write($data);
        warn "write failed\n"         unless ($count_out);
        warn "write incomplete\n"     if ( $count_out != length($data) );  

        return;
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {

        my $data=readPacket();

        my $crc=unpack("n",substr($data,-2,2));

        $data=substr($data,0,-2);

        my $crc16=rtu::crc($data);


        if ($crc !=$crc16)
        {
           print "\nCRC error!\n";
           
        }

        print "<";printData($data);

        return $data;
    }
#------------------------------------------------------
#------------------------------------------------------
# readPacket
#------------------------------------------------------
    sub readPacket {

        my $data="";

        my $mode=0;
        while (1)
        {
           my ($count_in, $string_in) = $comPort->read(1);
           if ($count_in != 1)
           {
               print "\nread fall:count_in=$count_in,string_in=$string_in\n";
               sleep(1); next;
           }
           if ($mode==0)
           {
              if ($string_in eq "\x7E")
              {
                 $mode=1;
              }

           }
           elsif ($mode==1)
           {
              if ($string_in eq "\x7E")
              {
                 last;
              }
              elsif ($string_in eq "\x7D")
              {
                 $mode=2;
                 next;
              }
              $data .= $string_in;
           }
           elsif ($mode==2)
           {
              $data .= pack("c",unpack("c",$string_in) | 0x20);

              $mode=1;
           }
           else
           {
              die;
           }
        }

        return $data;
    }
#------------------------------------------------------
1;
