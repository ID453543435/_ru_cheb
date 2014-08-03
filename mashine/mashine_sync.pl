#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use file_arch;
    use file_db;
    use strict;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# archivate
#------------------------------------------------------
sub archivate {


    my $list=file_db::dirList("database");

    my $lastFile1=shift @$list;
    my $lastFile2=shift @$list;

    if ($lastFile2)
    {
        file_arch::fileArch(substr($lastFile2,0,19));
    }

    for my $file (@$list)
    {
        my $arxFile=file_arch::fileArch(substr($file,0,19));
        unlink("database/$file");

        file_db::addFile($arxFile);
    }


}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    file_db::init();

    archivate();


}
#------------------------------------------------------
$|++;
main(@ARGV);
