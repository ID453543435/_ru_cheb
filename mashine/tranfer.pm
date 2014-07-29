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
# openPort
#------------------------------------------------------
    sub openPort {
        
        my $PortName="COM3";
        my $quiet=0;

        my $comPort = new Win32::SerialPort ($PortName, $quiet)
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
1;
