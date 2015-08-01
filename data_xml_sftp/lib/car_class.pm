#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
#    use fileLib;

    package car_class;
#------------------------------------------------------

    use vars qw(%data $timeFrom);
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


        return;
    }
#------------------------------------------------------
# giveClass
#------------------------------------------------------
    sub giveClass {
        my ($lenght)=@_;

        if ($lenght<6)
        {
           return "size_c0";
        }
        elsif ($lenght<9)
        {
           return "size_c3";
        }
        elsif ($lenght<11)
        {
           return "size_c4";
        }
        elsif ($lenght<13)
        {
           return "type_bus";
        }
        elsif ($lenght<22)
        {
           return "size_c5";
        }
        elsif ($lenght<30)
        {
           return "size_c6";
        }
        else
        {
           return "size_unknown";
        }

        return;
    }
#------------------------------------------------------
1;
