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
             PeerAddr => $parameters::com_port_adres,
             PeerPort => $parameters::com_port_port,
             Proto => 'tcp',
        ) or die "ERROR in Socket Creation : $!\n";

        binmode($socket);

        return;
    }
#------------------------------------------------------
# closePort
#------------------------------------------------------
    sub closePort {

        $socket->close || die "failed to close";

        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my ($data)=@_;

        my $count_out = $socket->syswrite($data);
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

        my $string_in="";
        my $count_in = 0;

        eval{
            alarm 5;
            $count_in = $socket->read($string_in,$bytes);
            alarm 0;
        }

        return ($count_in, $string_in);
    }
#------------------------------------------------------
#1;
