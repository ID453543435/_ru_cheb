#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use Cwd;
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# start
#------------------------------------------------------
    sub start {
        my ($str)=@_;


#        system("start /B /LOW $str");


        my $child_pid;
        if (!defined($child_pid = fork())) {
            die "cannot fork: $!";
        } elsif ($child_pid) {
            # I'm the parent
            print "start /B /LOW $str\n";
        } else {
            # I'm the child
            exec("perl", $str);
        } 

        return;
    }
#------------------------------------------------------
# compress
#------------------------------------------------------
    sub compress {
        my ($file,$arhFile,$dir)=@_;

        my $cwd=Cwd::getcwd();

        chdir($dir);

        system("gzip", "-k", "-S.gzip", $file);

        rename($file.".gzip",$arhFile);

        chdir($cwd);

        return;
    }
#------------------------------------------------------
