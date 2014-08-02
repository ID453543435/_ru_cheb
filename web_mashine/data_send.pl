#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME
base
=head1 SYNOPSIS

=cut
#------------------------------------------------------
     use strict;
     use m_cgi;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
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

    print "Uploading $filename to $file:\n";

    if (!$filename) {
#        print "You must enter a filename before you can upload it\n";
        return 404;
    }


    open (OUTFILE, ">", "$file") or die "Couldn't open $file for writing: $!";
    binmode(OUTFILE);

    while ($bytesread = read($filename, $buffer, $num_bytes)) {
        $totalbytes += $bytesread;
        print OUTFILE $buffer;
    }

    close OUTFILE or die "Couldn't close $file: $!";
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

    my $dataRes=saveFile($point_id."data.raw",  $m_cgi::cgi->upload('data'));
    my $dataArxRes=saveFile($point_id."data.7z",   $m_cgi::cgi->upload('data_arx'));


    print "dataRes=$dataRes\n";
    print "dataArxRes=$dataArxRes\n";


    $m_cgi::db->disconnect();
    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();