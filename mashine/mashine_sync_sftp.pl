#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);
    use Net::SFTP::Foreign;

    use strict;
    use parameters;
    use mashine_tools;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# sendSFTP
#------------------------------------------------------
sub sendSFTP {

    my $list=mashine_tools::dirList("data_xml");

#    print ::dump($list),"\n";

    @$list = grep(m{\.xml$}is, @$list);

#    print ::dump($list),"\n";

    @$list=sort(@$list);

    return unless @$list;

    my $sftp = Net::SFTP::Foreign->new($parameters::data_xml_sftp_adress, port => $parameters::data_xml_sftp_port
    , user => $parameters::data_xml_sftp_user, password => $parameters::data_xml_sftp_password);
    $sftp->die_on_error("Unable to establish SFTP connection");


    for my $file (@$list)
    {
        print "mashine_sync_sftp:<$file>\n";

        $sftp->put("data_xml/$file", "traffic/$file") or die "put failed: " . $sftp->error;

        unlink("data_xml/$file") or die;
    }


    $sftp->disconnect();

    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    parameters::initPost();

    my $errorCount=0;
    while (1)
    {

        eval{
           sendSFTP();
        }
        print "sendSFTP:$@;\n" if $@;
        sleep(60*1);
    
    }

#    <STDIN>;
}
#------------------------------------------------------
$|++;
main(@ARGV);
