#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use DBI;

    package data_base;
#------------------------------------------------------

    use vars qw($db $dbFile);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# makeDb 
#------------------------------------------------------
    sub makeDb {
        my ($db)=@_;

        $db->do("CREATE TABLE log (
        run_number INTEGER, 
        car_number INTEGER ,
        date_time  ,
        data
        );");

        $db->do("CREATE INDEX i001
        ON log ( run_number, car_number) ;");

        $db->do("CREATE INDEX i002
        ON log ( date_time) ;");

        return;
    }
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        $dbFile="database/dbfile.SQLite";
        $db = DBI->connect("DBI:SQLite:$dbFile",undef,undef) 
        or die "cant connect\n";
        makeDb($db) if -z $dbFile;

        return;
    }
#------------------------------------------------------
# saveData
#------------------------------------------------------
    sub saveData {
        my ($data)=@_;

#       push(@res,[$num,$chenel,$dirct,$timeL,$lenght,$speed]);

        print join(";",@$data),"\n";


        return;
    }
#------------------------------------------------------
1;
