#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS
=cut
#------------------------------------------------------
     use strict;
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
# printData
#------------------------------------------------------
    sub printData {
        my ($data)=@_;

        $data =~ s/(.)/sprintf("|%02x",ord($1))/esg; print "$data\n";
       
        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($data,$thisTime)=@_;

#        printData($data);

        my ($num,$chenel,$time,$lenght,$speed,$timeSec,$run_number,$carNumber)=unpack("CCLSCLLL",$data);

        my $dirct=$chenel & 0xf0;

        $chenel=$chenel & 0x0f;

        my $timeL=toSql($timeSec);

        if (($lenght>(64*50) or $speed>600) and $timeSec> $thisTime)
        {
             printData($data);
             print "(num=$num,chenel=$chenel($dirct),time=$time,\nlenght=$lenght,speed=$speed,timeSec=$timeSec($timeL),\nrun_number=$run_number,carNumber=$carNumber)\n";
             return 1;
        }
        return;
    }
#------------------------------------------------------
# printFile
#------------------------------------------------------
sub printFile {
    my ($fileName,$thisTime)=@_;


    open (INFILE, "<", $fileName) or die;
    binmode(INFILE);

    my $data;
    my $err=0;
    while (my $bytesread = read(INFILE, $data, 21)) {

       die if $bytesread !=21;

       $err += saveData($data,$thisTime);
       
    }

    close INFILE or die;

    print "^<$fileName>\n" if $err;

    return;
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
# checkDir
#------------------------------------------------------
sub checkDir {
    
    my $list=dirList(".");

    for my $file (@$list)
    {
#        print $file,"\n";

         next unless (substr($file,-4,4) eq ".dat");

         printFile($file,time());
    }


    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {
    my ($fileName)=@_;

    if ($fileName)
    {
       printFile($fileName);
    }
    else
    {
       checkDir();
    }
}
#------------------------------------------------------
$|++;
main(@ARGV);
