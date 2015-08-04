#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS
94.232.56.19:2121
Пользователь: ftppuid
Пароль: 59RjvAhfGjdFcn
=cut
#------------------------------------------------------
    use Data::Dump qw(dump);
    use File::Copy;
    use Net::FTP;
    
    use strict;

    package send_to_ftp;
#------------------------------------------------------
    use vars qw($data_xml_ftp_adress $data_xml_sftp_port);
    use vars qw($data_xml_ftp_user $data_xml_ftp_password);

    $data_xml_ftp_adress="94.232.56.19";
    $data_xml_sftp_port="2121";
    $data_xml_ftp_user="ftppuid";
    $data_xml_ftp_password="59RjvAhfGjdFcn";

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

#    print ::dump(\@files),":dirList\n";

#    shift @files; 
#    shift @files; 
    @files = grep(not( m{^\.\.?$}s), @files);
    
    return \@files;
}
#------------------------------------------------------
# sendFTP
#------------------------------------------------------
sub sendFTP {

    my $list=dirList("data_xml");

#    print ::dump($list),"\n";

    @$list = grep(m{\.xml$}is, @$list);

#    print ::dump($list),"\n";

    @$list=sort(@$list);

    return unless @$list;

    my $sftp = Net::FTP->new($data_xml_ftp_adress, Port=>$data_xml_sftp_port, Debug => 1, Passive=>1 );

    $sftp->login($data_xml_ftp_user,$data_xml_ftp_password);

    $sftp->binary();

#    $sftp->cwd('/pub/bc/');

    for my $file (@$list)
    {
        print "mashine_sync_sftp:<$file>\n";

        $sftp->put("data_xml/$file", "traffic/$file") or die "put failed: " . $sftp->message;

        unlink("data_xml/$file") or die;
    }


    $sftp->quit();
#    $sftp->disconnect();

    return;
}
#------------------------------------------------------
1;
