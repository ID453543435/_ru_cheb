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

    $ENV{PATH} .= q{;C:\Users\1\AppData\Local\GitHub\PortableGit_6d98349f44ba975cf6c762a720f8259a267ea445\bin\;};

    return;
}
#------------------------------------------------------
$select_from_last_N_states=21;
#------------------------------------------------------
1;
