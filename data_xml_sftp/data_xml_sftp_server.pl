#!"D:\xampp\perl\bin\perl.exe"
#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
BEGIN {
  push(@INC, 'lib');
}
#------------------------------------------------------
     use Data::Dump qw(dump);
     use File::Copy;

     use strict;
     use parameters;
     use data_base;
     use settings;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# dirList_num
#------------------------------------------------------
sub dirList_num {
    my ($dirname)=@_;

    my $list=mashine_tools::dirList($dirname);

#    print ::dump($list),"\n";

    @$list = grep(m{^\d+$}is, @$list);
    
    return $list;
}
#------------------------------------------------------
# serveAll
#------------------------------------------------------
sub serveAll {

    my $sth = $data_base::db->prepare(
        "SELECT id
         FROM points
         WHERE status=1
         ORDER BY id;");
    
    $sth->execute() or die $DBI::errstr;

    while (my @row = $sth->fetchrow_array()) {
       my ($point_id) = @row;
       saveToDB($point_id);

    }
    $sth->finish();

    
    $data_base::db->do("UPDATE points SET status=0 WHERE status=1;");
   
    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

    $parameters::tempFileDir='F:\prg_perl\_ru_cheb\web_mashine';

#    data_base::init();

    settings::init();

    print ::dump(\%settings::_data);

    die;


    while(1)
    {
        serveAll();
        sleep(1);
#        die;
    }
    
    data_base::disconnect();
}
#------------------------------------------------------
$|++;
main();
