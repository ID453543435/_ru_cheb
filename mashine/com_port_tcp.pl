#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use IO::Socket::INET;
    use strict;
#------------------------------------------------------
#    package com_port;

    use vars qw($socket);
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
        
        $socket = new IO::Socket::INET (
             LocalHost => "127.0.0.1",
             LocalPort => $parameters::tor_incomePort,
             Proto => 'tcp',
             Listen => 5,
             ReuseAddr => 1
        ) or die "ERROR in Socket Creation : $!\n";

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
