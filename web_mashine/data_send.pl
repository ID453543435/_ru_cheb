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
    my ($filename,$file)=@_;
    
        my ($bytesread, $buffer);
        my $num_bytes = 1024;
        my $totalbytes= 0;

        print "Uploading $filename to $file:\n";

        if (!$filename) {
            print "You must enter a filename before you can upload it\n";
            return;
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
            print "<p>Done. File $filename uploaded to $file ($totalbytes bytes)\n";
        }
        else
        {
            print "Read failure\n";
            unlink($file);
        }

    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    m_cgi::init();
    m_cgi::connectDB();

    my $point_id=$m_cgi::cgi->param('point_id');

    saveFile($m_cgi::cgi->upload('data'),$point_id."data.raw");
    saveFile($m_cgi::cgi->upload('data_arx'),$point_id."data.7z");


#    print "point_id=".sprintf("%08i",$point_id)."\n";



    $m_cgi::db->disconnect();
    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();
