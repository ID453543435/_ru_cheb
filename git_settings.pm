#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
#------------------------------------------------------
    package git_settings;

    use vars qw($select_from_last_N_states);

#------------------------------------------------------
# controlArea
#------------------------------------------------------
sub controlArea {

    system("git", "add", "*.h");
    system("git", "add", "*.cc");
    system("git", "add", "*.pl");
    system("git", "add", "*.pm");
    system("git", "add", "*.txt");
    system("git", "add", "README");

    return;
}
#------------------------------------------------------
# getVersion
#------------------------------------------------------
sub getVersion {

    my $ver=fileLib::fileToStr('[git]version.txt');
    chomp($ver);
    return $ver;
}
#------------------------------------------------------
# setEnv
#------------------------------------------------------
sub setEnv {

    $ENV{PATH} .= q{;C:\Users\1\AppData\Local\GitHub\PortableGit_054f2e797ebafd44a30203088cd3d58663c627ef\bin;};

    return;
}
#------------------------------------------------------
$select_from_last_N_states=21;
#------------------------------------------------------
1;
