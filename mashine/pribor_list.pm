#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use pribor;
#------------------------------------------------------
    package pribor_list;

    use vars qw(@pribor_list);
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

        @pribor_list=();
        for(my $i=0;$i<@parameters::dev_adress;$i++)
        {
            my $adress= $parameters::dev_adress[$i];
            my $pribor=new pribor($adress);

            $pribor->{chanel}=$i*2;

            push(@pribor_list,$pribor);

        }

        return;
    }
#------------------------------------------------------
# readyUp
#------------------------------------------------------
    sub readyUp {

        for my $pribor (@pribor_list)
        {
            pribor::readyUp($pribor);
        }

        return;
    }
#------------------------------------------------------
# syncTime
#------------------------------------------------------
    sub syncTime {

        for my $pribor (@pribor_list)
        {
            pribor::syncTime($pribor);
        }

        return;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {

        for my $pribor (@pribor_list)
        {
            pribor::readCars($pribor);
        }

        return;
    }
#------------------------------------------------------
1;
