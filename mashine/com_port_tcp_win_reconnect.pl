#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use IO::Socket::INET;
    use IO::Select;
    use strict;
#------------------------------------------------------
#    package com_port;

    use vars qw($socket $select);
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

        $select = IO::Select->new;
        $select->add( $socket );

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

#        print "<";

        my @ready = $select->can_read( 1 );
        if (@ready > 0) {
            $count_in = $socket->sysread($string_in,$bytes);
        } else {
#            warn "data not available on socket now";
        }        

#        print "$count_in>";

        return ($count_in, $string_in);
    }
#------------------------------------------------------
#1;
