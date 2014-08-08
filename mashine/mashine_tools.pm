#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
 
    package mashine_tools;
#------------------------------------------------------

#    use vars qw($post_file_name $post_input_name $post_file_short);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# dateHour
#------------------------------------------------------
    sub dateHour {
        my ($timeL)=@_;

        my $dateHour=substr($timeL,0,13);

        $dateHour =~ tr/\- //d;

        return $dateHour;
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
# saveSelectBin
#------------------------------------------------------
    sub saveSelectBin {
        my ($db,$request,$params,$dbFile)=@_;

        my $sth = $db->prepare($request);
        
        $sth->execute(@$params) or die $DBI::errstr;

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

        return($tempFile, $run_number, $car_number, $date_time);
    }
#------------------------------------------------------
1;
