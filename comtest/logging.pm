#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use settings;

    package logging;
    use Fcntl qw(:flock SEEK_END); 
#------------------------------------------------------

    use vars qw($file $logDate);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# время в формате
#------------------------------------------------------
    sub timeStr {

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
         = localtime();

        $year+=1900;
        $mon++;


        return sprintf("%04i-%02i-%02i %02i:%02i:%02i",$year,$mon,$mday, $hour,$min,$sec);

    }
#------------------------------------------------------
# openLog
#------------------------------------------------------
    sub openLog {
        my ($fileName)=@_;

        if ($fileName eq $logDate)
        {
            return;
        }

        if ($file)
        {
            closeLog();
        }

        open ($file,">>${settings::logFolder}/$fileName.log") or die $!;

        $logDate=$fileName;

        my $oldfh = select($file); $| = 1; select($oldfh);

        return;
    }
#------------------------------------------------------
# closeLog
#------------------------------------------------------
    sub closeLog {

        close ($file) or die "cant close log file";

        return;
    }
#------------------------------------------------------
# logPrint
#------------------------------------------------------
    sub logPrint {

        my ($timeStr, @ozer)=@_;

        print ">";

        flock($file, LOCK_EX | LOCK_NB) or die $!;
        seek $file, 0, SEEK_END or die $!;

        print $file "=[$timeStr]==========\n",@ozer,"\n";

        flock($file, LOCK_UN) or die $!;

        print @ozer,"\n";

        return;
    }
#------------------------------------------------------
# lprint
#------------------------------------------------------
    sub lprint {
        my ($imei,$mess)=@_;

        my $dateTime=timeStr();
        my $imei8;
        if ($imei)
        {
           $imei8=substr($imei,-8,8);
        }
        else
        {
           $imei8="connect";
        }

        my $fileName=$imei8."-".substr($dateTime,2,8);
        openLog($fileName);
        logPrint("$dateTime $imei $$" ,$mess);

        return;
    }
#------------------------------------------------------
1;
