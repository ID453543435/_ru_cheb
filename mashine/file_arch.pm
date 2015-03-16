#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use DBI;
    use strict;
    use fileLib;
#    use a7z;
    use os_spec;
    use mashine_tools;

    package file_arch;
    use File::Copy;
#------------------------------------------------------

#    use vars qw($db $dbFile $dbDateHour $dbCarNumber);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# openDataBase
#------------------------------------------------------
    sub openDataBase {
        my ($dbFile)=@_;

        my $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";

        return $db;
    }
#------------------------------------------------------
# fileArch
#------------------------------------------------------
    sub fileArch {
        my ($dbFile)=@_;
        
        my $db = mashine_tools::openDataBase("database/$dbFile.SQLite");
        
        my $request= "SELECT run_number, car_number, date_time, data
             FROM log ORDER BY run_number, car_number ;";

        my ($tempFile, $run_number, $car_number, $date_time)=mashine_tools::saveSelectBin($db,$request,[],$dbFile);
        
        $db->disconnect();

        return ("") unless $tempFile;

        my $arxName= $dbFile.sprintf("_%08i_%08i", $run_number, $car_number).".gzip";

        os_spec::compress($dbFile,$arxName,"temp");

        move("temp/$arxName","archives/$arxName") or die;

        unlink($tempFile) or die;

        return ($arxName);
    }
#------------------------------------------------------
1;
