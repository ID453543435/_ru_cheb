#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use pribor;
    use fileLib;
#------------------------------------------------------
    package read_pass;

#    use vars qw($comPort);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# readCars
#------------------------------------------------------
    sub readCars {
        my ($pribor)=@_;


        my $data=pribor::readCars($pribor);
#       push(@res,[$num,$chenel,$dirct,$timeL,$lenght,$speed]);
    
        for my $str (@$data)
        {
            data_base::saveData($str);
        }


        return;
    }
#------------------------------------------------------
1;
