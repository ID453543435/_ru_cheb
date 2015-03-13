#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use IO::Socket::INET;
    use IO::Select;
    use strict;
    use pribor_radar;
#------------------------------------------------------
#    package com_port;

    $parameters::com_port_adres=$parameters::radar_adres;
    $parameters::com_port_port=$parameters::radar_port;

    do("com_port_tcp_win_reconnect.pl");

#------------------------------------------------------
#1;
