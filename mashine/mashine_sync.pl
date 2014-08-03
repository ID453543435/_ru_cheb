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

    @$list=sort(@$list);

    my $lastFile1=pop @$list;
    my $lastFile2=pop @$list;

    if ($lastFile2)
    {
        my $arxFile=file_arch::fileArch(substr($lastFile2,0,19));
        file_db::addFile($arxFile);
    }

    for my $file (@$list)
    {
        my $arxFile=file_arch::fileArch(substr($file,0,19));
        unlink("database/$file") or die;

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
