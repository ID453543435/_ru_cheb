#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use CGI; # load CGI routines
    use DBI;
    use strict;
#------------------------------------------------------
    package m_cgi;

    use vars qw($cgi $db);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# connectDB
#------------------------------------------------------
    sub connectDB {

        # MySQL database configurations
        my $dsn = "DBI:mysql:mashine";
        my $username = "root";
        my $password = '';

        # connect to MySQL database
        my %attr = (PrintError=>0, RaiseError=>1);

        $db = DBI->connect($dsn,$username,$password, \%attr);

        return;
    }
#------------------------------------------------------
# SQLrow
#------------------------------------------------------
    sub SQLrow {
        my ($request,$params)=@_;

        my $sth = $db->prepare($request);
        
        $sth->execute(@{$params}) or die $DBI::errstr;
#        print "Number of rows found :" . $sth->rows . "\n";

        my @res;
        while (my @row = $sth->fetchrow_array()) {
           @res=@row;
        }
        $sth->finish();    

        return @res;
    }
#------------------------------------------------------
# header
#------------------------------------------------------
sub header {

    print $cgi->start_html('mserv'); # start the HTML
    print $cgi->h1('mserv'); # level 1 header

    print "<PRE>\n";
    print "<!---beg--->\n";


    return;
}
#------------------------------------------------------
# fin
#------------------------------------------------------
sub fin {

    print "<!---end--->\n";
    print "</PRE>\n";
    print $cgi->end_html; # end the HTML

    return;
}
#------------------------------------------------------
# init
#------------------------------------------------------
sub init {

    $cgi = CGI->new; # create new CGI object
    print $cgi->header; # create the HTTP header

    header();

    return;
}
#------------------------------------------------------
1;
