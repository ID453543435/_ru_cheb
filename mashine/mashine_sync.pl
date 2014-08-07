#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use parameters;
    use file_arch;
    use file_db;
    use post_data;
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
        file_db::fileArch(substr($lastFile2,0,19));
    }

    for my $file (@$list)
    {
        file_db::fileArch(substr($file,0,19));
        unlink("database/$file") or die;
    }


}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    parameters::initPost();
    file_db::init();

    archivate();

    post_data::post();

    <STDIN>;

}
#------------------------------------------------------
$|++;
main(@ARGV);
