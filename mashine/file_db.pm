#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Data::Dump qw(dump);

    use strict;
    
    use file_arch;
    use mashine_tools;
    package file_db;
#------------------------------------------------------

    use vars qw(%files $lastDateHour $fistDateHour);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# deleteFile
#------------------------------------------------------
    sub deleteFile {
        my ($dateHour)=@_;


        my $fileName=${$files{$dateHour}}[0];

        delete($files{$dateHour});

        unlink("archives/".$fileName) or die;


        return;
    }
#------------------------------------------------------
# diskOk
#------------------------------------------------------
    sub diskOk {


        if(keys(%files) > 25*31)
        {
           return 0;
        }

        return 1;
    }
#------------------------------------------------------
# freeDisk
#------------------------------------------------------
    sub freeDisk {

        my @dates=sort(keys(%files));

#        print "freeDisk[---=$file_db::fistDateHour=$file_db::lastDateHour=\n";

        while(not diskOk())
        {
            last unless ${$files{$dates[0]}}[2];

            my $dateTime=shift(@dates);

            deleteFile($dateTime);
        }

        $fistDateHour=shift(@dates) if @dates;

#        print "freeDisk[---=$file_db::fistDateHour=$file_db::lastDateHour=\n";

        return;
    }
#------------------------------------------------------
# addFileData
#------------------------------------------------------
    sub addFileData {
        my ($file,$baseName,$point_code,$dateHour,$run_number, $car_number)=@_;

#        print "file_db.pm[$dateHour=$file_db::fistDateHour=$file_db::lastDateHour=\n";

        $files{$dateHour}=[$file,$baseName,$run_number, $car_number,$point_code];

        if ($dateHour gt $lastDateHour)
        {
            $lastDateHour=$dateHour;
        }

        if ($dateHour lt $fistDateHour)
        {
            $fistDateHour=$dateHour;
        }
#        print "file_db.pm]$dateHour=$file_db::fistDateHour=$file_db::lastDateHour=\n";
        
        return;
    }
#------------------------------------------------------
# addFile
#------------------------------------------------------
    sub addFile {
        my ($file)=@_;

        my ($point_code,$dateHour,$run_number, $car_number)=($file =~ m{^(.{8})_(.{10})_(.{8})_(.{8})}s);
        my $baseName=substr($file,0,19);

        addFileData($file,$baseName,$point_code,$dateHour,$run_number, $car_number);

        return;
    }
#------------------------------------------------------
# fileArch
#------------------------------------------------------
    sub fileArch {
        my ($file)=@_;

        my ($point_code,$dateHour)=($file =~ m{^(.{8})_(.{10})}s);

        my $arxName;

        if (${$files{$dateHour}}[2])
        {
            $arxName=${$files{$dateHour}}[0];
        }
        else
        {
            $arxName=file_arch::fileArch($file);
            addFile($arxName) if $arxName;
        }

        return ($arxName);
    }
#------------------------------------------------------
# fileData
#------------------------------------------------------
    sub fileData {
        my ($dateHour)=@_;


        if ($files{$dateHour})
        {
            return( @{$files{$dateHour}} );
        }
        else
        {
            return("");
        }

        return;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        %files=();
        $lastDateHour="0001010100";
        $fistDateHour="9999999999";

        my $list=mashine_tools::dirList("archives");

        for my $file (@$list)
        {
             addFile($file);
        }

        return;
    }
#------------------------------------------------------
1;
