#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use DBI;
    use strict;
    use fileLib;
    use a7z;

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


        $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";

        return $db;
    }
#------------------------------------------------------
# fileArch
#------------------------------------------------------
    sub fileArch {
        my ($dbFile)=@_;

        $db = openDataBase("database/$dbFile");
        
        my $sth = $db->prepare(
            "SELECT run_number, car_number, date_time, data
             FROM log ORDER BY run_number, car_number ;");
        
        $sth->execute() or die $DBI::errstr;

        print "Number of rows found :" . $sth->rows . "\n";


        my $tempFile="temp/$dbFile";

        open (OUTFILE, ">", $tempFile) or die "cant open";
        binmode(OUTFILE);

        my ($run_number, $car_number, $date_time, $data);
        while (my @row = $sth->fetchrow_array()) {
           ($run_number, $car_number, $date_time, $data) = @row;

           print OUTFILE $data;
        }
        $sth->finish();    
        
        close OUTFILE or return die "cant close";

        a7z::compress($dbFile,"temp");

        my $arxName= $dbFile.sprintf("_%08i_%08i", $run_number, $car_number);

        move($tempFile,"archives/$arxName");

        unlink($tempFile);

        return ($arxName);
    }
#------------------------------------------------------
1;
