#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;

    package file_db;
    use file_arch;
#------------------------------------------------------

    use vars qw(%files $lastDateHour);
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
# addFile
#------------------------------------------------------
    sub addFile {
        my ($file)=@_;

        my ($point_code,$dateHour,$run_number, $car_number)=($file =~ m{^(.{8})_(.{10})_(.{8})_(.{8})}s);
        my $baseName=substr($file,0,19);
        $files{$dateHour}=[$file,$baseName,$run_number, $car_number,$point_code];

        if ($dateHour gt $lastDateHour)
        {
            $lastDateHour=$dateHour;
        }

        return;
    }
#------------------------------------------------------
# fileArch
#------------------------------------------------------
    sub fileArch {
        my ($file)=@_;

        my ($point_code,$dateHour)=($file =~ m{^(.{8})_(.{10})}s);

        my $arxName;

        if ($files{$dateHour})
        {
            $arxName=${$files{$dateHour}}[0];
        }
        else
        {
            $arxName=file_arch::fileArch($file);
            addFile($arxName);
        }

        return ($arxName);
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        %files=();

        my $list=dirList("archives");

        for my $file (@$list)
        {
             addFile($file);
        }

        return;
    }
#------------------------------------------------------
1;
