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
    use Net::SFTP::Foreign;
#    use Net::SSH2;
    use Data::Dump qw(dump);
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


    my $sftp = Net::SFTP::Foreign->new("95.53.129.30", port => "3058", user => "novgufa", password => "NNovUf536");
    $sftp->die_on_error("Unable to establish SFTP connection");

    $sftp->put("test_ssh_sftp2.pl", "traffic/test.txt") or die "put failed: " . $sftp->error;

    $sftp->disconnect();


}
#------------------------------------------------------
$|++;
main(@ARGV);
