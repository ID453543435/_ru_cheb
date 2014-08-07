#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
#------------------------------------------------------
    use Cwd;

    package a7z;

    use vars qw($conf_rar);

    $conf_rar='C:\Program Files\7-Zip\7z.exe';

#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# extention
#------------------------------------------------------
sub extention {

    return "7z";
}
#------------------------------------------------------
# compress
#------------------------------------------------------
sub compress {
    my ($file,$arhFile,$dir)=@_;

    my $cwd=Cwd::getdcwd();

    chdir($dir);

    system($conf_rar, "a", "-tgzip", $arhFile, $file);

    chdir($cwd);

    return;
}
#------------------------------------------------------
# decompress
#------------------------------------------------------
sub decompress {
    my ($arhFile,$dir)=@_;

    my $cwd=Cwd::getdcwd();

    chdir($dir);

    system($conf_rar, "e", "-tgzip", $arhFile);

    chdir($cwd);

    return;
}
#------------------------------------------------------
1;
