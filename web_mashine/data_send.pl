#!perl.exe
#------------------------------------------------------
=head1 NAME
base
=head1 SYNOPSIS

=cut
#------------------------------------------------------
     use strict;
     use parameters;
     use m_cgi;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# время в sql формат из UNIX
#------------------------------------------------------
    sub toSql {
        my ($par)=@_;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                            gmtime($par);

        $year+=1900;
        $mon++;

        ($mon,$mday,$hour,$min,$sec)=map(substr("00".$_,-2,2),($mon,$mday,$hour,$min,$sec));

        return "$year-$mon-$mday $hour:$min:$sec";

    }
#------------------------------------------------------
# saveFile
#------------------------------------------------------
sub saveFile {
    my ($file,$filename)=@_;
    
    my ($bytesread, $buffer);
    my $num_bytes = 1024;
    my $totalbytes= 0;
    my $res=0;

#    print "Uploading $filename to $file:\n";

    if (!$filename) {
#        print "You must enter a filename before you can upload it\n";
        return 404;
    }


    open (OUTFILE, ">", "$file") or return 331;
    binmode(OUTFILE);

    while ($bytesread = read($filename, $buffer, $num_bytes)) {
        $totalbytes += $bytesread;
        print OUTFILE $buffer;
    }

    close OUTFILE or return 332;
    if (defined($bytesread))
    {
#        print "<p>Done. File $filename uploaded to $file ($totalbytes bytes)\n";
        $res=200;
    }
    else
    {
#        print "Read failure\n";
        unlink($file);
        $res=305;
    }

    return $res;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    m_cgi::init();
    m_cgi::connectDB();

    my $point_id=$m_cgi::cgi->param('point_id');

    $m_cgi::db->do("UPDATE points SET status=201 WHERE id=? ;",{},($point_id));
    

    my $pointDir=$parameters::tempFileDir.sprintf("%08i/",$point_id);

    mkdir($pointDir);


    my $dataRes   =saveFile($pointDir.$m_cgi::cgi->param('data'),       $m_cgi::cgi->upload('data'));
    my $dataArxRes=saveFile($pointDir.$m_cgi::cgi->param('data_arx'),   $m_cgi::cgi->upload('data_arx'));


    print "dataRes=$dataRes\n";
    print "dataArxRes=$dataArxRes\n";


    my $status=0;
    if ($dataRes==200 or $dataArxRes==200)
    {
        $status=1;
    }

    $m_cgi::db->do("UPDATE points SET status=?, data_send=? WHERE id=? ;",{},($status,toSql(time()),$point_id));

    $m_cgi::db->disconnect();
    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();
