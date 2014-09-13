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
# saveSelectBinZ
#------------------------------------------------------
    sub saveSelectBinZ {
        my ($db,$request,$params,$dbFile)=@_;

        my $sth = $db->prepare($request);
        
        $sth->execute(@$params) or die $DBI::errstr;
#        print "Number of rows found :" . $sth->rows . "\n";
        
        my $tempFile="temp/$dbFile";

        open (OUTFILE, ">", $tempFile) or die "cant open";
        binmode(OUTFILE);

        my ($run_number, $car_number, $date_time, $data);
        while (my @row = $sth->fetchrow_array()) {
           ($run_number, $car_number, $date_time, $data) = @row;

           print OUTFILE $data;
        }
        $sth->finish();    
        
        close OUTFILE or die "cant close";

        return($tempFile, $run_number, $car_number, $date_time);
    }
#------------------------------------------------------
# saveSelectBin
#------------------------------------------------------
    sub saveSelectBin {
        my ($db,$request,$params,$dbFile)=@_;


        my ($tempFile, $run_number, $car_number, $date_time)=saveSelectBinZ($db,$request,$params,$dbFile);

        unless($run_number)
        {
            unlink($tempFile) or die "cant unlink";
            $tempFile="";
        }


        return($tempFile, $run_number, $car_number, $date_time);
    }
#------------------------------------------------------
# strToHASH
#------------------------------------------------------
    sub strToHASH {
        my ($str)=@_;

        my %res=();

        while ( $str =~ m{^(\w+)=(.*)$}mgi ) 
        {
          $res{$1}=$2;
        }
        
        return \%res;
    }
#------------------------------------------------------
# parseHTML
#------------------------------------------------------
    sub parseHTML {
        my ($str)=@_;

        return ({}) 
        if not ($str =~ m{<!---beg--->}gi);
        my $fromPoz=pos($str);

        return ({}) 
        if not ($str =~ m{<!---end--->}gi);
        my $toPoz=pos($str);
        
        return strToHASH(substr($str,$fromPoz,$toPoz-$fromPoz));
    }
#------------------------------------------------------
1;
