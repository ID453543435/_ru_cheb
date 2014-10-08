#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
#------------------------------------------------------
    package os_spec;

#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

#        do("os_spec_${^O}.pl");

        unless (my $return = do("os_spec_${^O}.pl")) {
             warn "couldn't parse : $@" if $@;
             warn "couldn't do : $!" unless defined $return;
             warn "couldn't run" unless $return;
        }        

        return;
    }
#------------------------------------------------------
1;
