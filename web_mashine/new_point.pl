#!perl.exe
#------------------------------------------------------
=head1 NAME
base
=head1 SYNOPSIS

=cut
#------------------------------------------------------
     use strict;
     use m_cgi;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    m_cgi::init();

    m_cgi::connectDB();

    $m_cgi::db->do("INSERT INTO points (status) VALUES (0) ;");
    
    my $sth = $m_cgi::db->prepare(
        "SELECT id
         FROM points
         ORDER BY id DESC LIMIT 1;");
    
    $sth->execute() or die $DBI::errstr;

    print "Number of rows found :" . $sth->rows . "\n";

    my $id;
    while (my @row = $sth->fetchrow_array()) {
       ($id ) = @row;
    }
    $sth->finish();    

    print "num=".sprintf("%08i",$id)."\n";

    $m_cgi::db->disconnect();

    m_cgi::fin();
}
#------------------------------------------------------
#$|++;
main();
