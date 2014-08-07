#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME
base
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
     my %attr = (PrintError=>0, RaiseError=>1);

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

     $dbh->do("
     CREATE TABLE data (
     point_id   int(8) ,
     run_number int(8) ,
     car_number int(8) ,
     date_time  DATETIME ,
     data       varchar(65) ,
     KEY k001 (date_time),
     KEY k002 (point_id,date_time),
     UNIQUE KEY k003 (point_id,run_number,car_number)
     );
     ");


     # disconnect from the MySQL database
     $dbh->disconnect();

}
#------------------------------------------------------
$|++;
main();
