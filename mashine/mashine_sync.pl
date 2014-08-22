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

    while (1)
    {
        archivate();

        my $status=post_data::post();

        my $sleepTime=0;

        if ($status == 501)  #my error
        {
           $sleepTime=1;
        } elsif ($status >= 300 and $status < 400) #internet error
        {
           $sleepTime=30;
        } elsif ($status >= 400 and $status < 500) #wait for server finish processing
        {
           $sleepTime=15;
        } elsif ($status >= 200 and $status < 300) #ok
        {
           $sleepTime=15;
           if ($status == 200)  # sended last data
           {
               $sleepTime=5*60;
           }
        }

        print "status=$status;sleepTime=$sleepTime\n";

        sleep($sleepTime);
    }

    <STDIN>;
}
#------------------------------------------------------
$|++;
main(@ARGV);
