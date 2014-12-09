#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS
Ваши данные для доступа на сервер sftp://95.53.129.30:3058
Логин: novgufa
Пароль: NNovUf536
=cut
#------------------------------------------------------
    use strict;
#    use Net::SFTP;
#    use Net::SFTP::Foreign;
    use Data::Dump qw(dump);
    use Net::SSH2;
    use Fcntl;
    use Fcntl ':DEFAULT';
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {


    my $ssh = new Net::SSH2;
    $ssh->debug(1);
    $ssh->blocking(1);

    $ssh->connect("95.53.129.30:3058") or die "cannot SSH2 connect";

    $ssh->auth( username => "novgufa", password => "NNovUf536") or die "wrong password";

    my $sftp = $ssh->sftp() or die "dont have sftp";

#    my $dir=$sftp->opendir ("/");

#    my $files=$dir->read();

#    print ::dump($files);


#    my $remote = $sftp->open("traffic/test.txt", O_CREAT, 0666) or die "cannot open file";
    my $remote = $sftp->open("traffic/test.txt", O_CREAT) or die "cannot open file";
    my $bytes=$remote->write("Test Home Page");
    print "write=$bytes;\n";


#    $ssh->scp_put("test_ssh_sftp.pl","traffic/test.txt");

#    $remote->flush();
#    $remote->close();

#    $sftp->close();

    $ssh->disconnect();


}
#------------------------------------------------------
$|++;
main(@ARGV);
