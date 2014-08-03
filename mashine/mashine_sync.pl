#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use file_arch;
    use strict;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# dirList
#------------------------------------------------------
sub dirList {
    my ($dirname)=@_;

    opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
    my @files = readdir $dh;
    closedir $dh;

    pop @files; 
    pop @files; 

    return \@files;
}
#------------------------------------------------------
# archivate
#------------------------------------------------------
sub archivate {


    my $list=dirList("database");

    my $lastFile1=shift @$list;
    my $lastFile2=shift @$list;

    if ($lastFile2)
    {
        file_arch::fileArch($lastFile2);
    }

    for my $file (@$list)
    {
        file_arch::fileArch($file);
        unlink("database/$file");
    }


}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {




}
#------------------------------------------------------
$|++;
main(@ARGV);
