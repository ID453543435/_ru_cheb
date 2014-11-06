#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);

    use strict;
    use parameters;
    use file_arch;
    use file_db;
    use post_data;
    use os_spec;
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

#    print ::dump($list),"\n";

    @$list = grep(m{\.SQLite$}is, @$list);

#    print ::dump($list),"\n";

    @$list=sort(@$list);

#    print ::dump($list),"\n";

    my $lastFile1=pop @$list;
    
    my ($point_code,$dateHour)=($lastFile1 =~ m{^(.{8})_(.{10})}s);
    my $baseName=substr($lastFile1,0,19);


#    print "mashine_sync.pl:($lastFile1,$baseName,$point_code,$dateHour)\n";
    
    file_db::addFileData($lastFile1,$baseName,$point_code,$dateHour, "", "");

    
    my $lastFile2=pop @$list;


#    print "lastFile2=$lastFile2;lastFile1=$lastFile1;\n";

    if ($lastFile2)
    {
        my $arxFile=file_db::fileArch(substr($lastFile2,0,19));
        unlink("database/$lastFile2") unless $arxFile;
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
    os_spec::init();
    file_db::init();
    post_data::init();

    while (1)
    {
        file_db::freeDisk();
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

        print "${parameters::point_code}:status=$status;sleepTime=$sleepTime\n";

        sleep($sleepTime);
    }

    <STDIN>;
}
#------------------------------------------------------
$|++;
main(@ARGV);
