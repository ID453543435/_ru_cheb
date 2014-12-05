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
     use fileLib;
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

    my $point_id=$m_cgi::cgi->param('point_id');

    my $pointDir=$parameters::tempFileDir."settings/".sprintf("%08i/",$point_id);

    my $dataRes   =saveFile($pointDir."current/settings.pl",       $m_cgi::cgi->upload('data'));


    fileLib::strToFile($pointDir."last_ip",$m_cgi::cgi->remote_host());

    print "dataRes=$dataRes\n";

    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();
