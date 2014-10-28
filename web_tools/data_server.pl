#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS
=cut
#------------------------------------------------------
     use strict;
     use parameters;
     use data_base;
     use a7z;
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

    shift @files; 
    shift @files; 

    return \@files;
}
#------------------------------------------------------
# saveToDBfile
#------------------------------------------------------
sub saveToDBfile {
    my ($point_id,$fileName)=@_;


    open (INFILE, "<", $fileName) or die;
    binmode(INFILE);

    my $data;
    while (my $bytesread = read(INFILE, $data, 21)) {

       die if $bytesread !=21;

       data_base::saveData($point_id,$data);
       
    }

    close INFILE or die;

    return;
}
#------------------------------------------------------
# saveToDB
#------------------------------------------------------
sub saveToDB {
    my ($point_id)=@_;
    
    my $pointDir=$parameters::tempFileDir.sprintf("%08i/",$point_id);


    my $list=dirList($pointDir);

    for my $file (@$list)
    {
        print $pointDir.$file,"\n";

        if (substr($file,-5,5) eq ".gzip")
        {
            my $arxFile=$file;
            $file=substr($arxFile,0,19);

            a7z::decompress($arxFile,$pointDir);

            if (-f($pointDir.$file))
            {
                saveToDBfile($point_id,$pointDir.$file);

                unlink($pointDir.$arxFile) or die;
                unlink($pointDir.$file) or die;
            }
        }
        else
        {
            saveToDBfile($point_id,$pointDir.$file);
            unlink($pointDir.$file) or die;
        }
    }


    return;
}
#------------------------------------------------------
# serveAll
#------------------------------------------------------
sub serveAll {

    my $sth = $data_base::db->prepare(
        "SELECT id
         FROM points
         WHERE status=1
         ORDER BY id;");
    
    $sth->execute() or die $DBI::errstr;

    while (my @row = $sth->fetchrow_array()) {
       my ($point_id) = @row;
       saveToDB($point_id);

    }
    $sth->finish();

    
    $data_base::db->do("UPDATE points SET status=0 WHERE status=1;");
   
    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    data_base::init();


    while(1)
    {
        serveAll();
        sleep(1);
#        die;
    }
    
    data_base::disconnect();
}
#------------------------------------------------------
$|++;
main();
