#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS
=cut
#------------------------------------------------------
     use DBI;
     use strict;
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

     # MySQL database configurations
     my $dsn = "DBI:mysql:test";
     my $username = "root";
     my $password = '';

     # connect to MySQL database
     my %attr = (PrintError=>1, RaiseError=>1);

     my $dbh = DBI->connect($dsn,$username,$password, \%attr);

     $dbh->do("DROP DATABASE mashine;");

     $dbh->do("CREATE DATABASE mashine;");

     $dbh->do("USE mashine;");

     $dbh->do("
     CREATE TABLE points (
     id       int(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
     status   int(8) ,
     info     varchar(255) NOT NULL
     );
     ");

#        (run_number, car_number, date_time, data) 


#     data       varchar(65) ,

     $dbh->do("
     CREATE TABLE data (
     pointid   int(8) ,
     runnumber int(8) ,
     carnumber int(8) ,
     datetime  DATETIME ,

     direct int(2) ,
     chenel int(2) ,
     lengh int(6) ,
     speed  int(3) ,

     KEY k001 (datetime),
     KEY k002 (pointid,datetime),
     UNIQUE KEY k003 (pointid,runnumber,carnumber)
     );
     ");


     # disconnect from the MySQL database
     $dbh->disconnect();

}
#------------------------------------------------------
$|++;
main();
