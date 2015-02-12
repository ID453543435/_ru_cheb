#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Device::SerialPort;
    use strict;
#------------------------------------------------------
#    package com_port;

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
        
        my $PortName=$parameters::com_port_linux_file;
        my $quiet=0;

        $comPort = new Device::SerialPort ($PortName, $quiet)
             || die "Can't open $PortName: $^E\n";    # $quiet is optional

        $comPort->user_msg("ON");
        $comPort->databits(8);
        $comPort->baudrate(9600);
        $comPort->parity("none");
        $comPort->stopbits(1);
#        $comPort->handshake("rts");
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

        my $count_out = $comPort->write($data);
#        warn "write failed\n"         unless ($count_out);
#        warn "write incomplete\n"     if ( $count_out != length($data) );  

#        sleep(0.1);

        return $count_out;
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {
        my ($bytes)=@_;

        my ($count_in, $string_in) = $comPort->read($bytes);

        return ($count_in, $string_in);
    }
#------------------------------------------------------
#1;
