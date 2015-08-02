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
use Time::Local;

     use strict;
     use parameters;
     use data_base;
     use settings;
     use data_xml_sftp;
     use data_xml_sftp_pat;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# dataSave
#------------------------------------------------------
sub dataSave {
    my ($point_id,$data_sended,$data_send)=@_;


    my $sth = $data_base::db->prepare(
        "SELECT pointid, runnumber, carnumber, datetime
        ,direct ,chenel ,lengh ,speed
         FROM data
         WHERE pointid=CAST( ? AS UNSIGNED)
         AND datetime >= ? AND datetime < ?
         ORDER BY pointid, datetime;");
    
    $sth->execute($data_sended,$data_send) or die $DBI::errstr;

    while (my @row = $sth->fetchrow_array()) {
       my ($point_id,$run_number,$carNumber,$timeL
        ,$dirct,$chenel,$lenght,$speed) = @row;

       my $timeSec=fileLib::toUnix($timeL);

       data_xml_sftp::data_saveData(1,$dirct,$chenel,$timeSec,$lenght,$speed);

    }
    $sth->finish();


    $data_base::db->do("UPDATE xml SET data_sended=? WHERE pointid=CAST( ? AS UNSIGNED);"
    ,{}, ($data_send,$point_id) );

    return;
}
#------------------------------------------------------
# getSendDatetime
#------------------------------------------------------
sub getSendDatetime {
    my ($point_id)=@_;

    my ($id,$data_sended) = data_base::SQLrow("SELECT pointid, data_sended FROM xml WHERE pointid=CAST( ? AS UNSIGNED);",[$point_id]);

    unless ($id)
    {
#        my ($cur_actual) = data_base::SQLrow("SELECT data_actual FROM points WHERE id=CAST( ? AS UNSIGNED);",[$point_id]);

        my $datetime_gm=fileLib::toSql(time());
        my ($year,$mon,$mday,$hour,$min,$sec)=
        ($datetime_gm =~ /(....)-(..)-(..) (..):(..):(..)/);

        my $data_sended_gm=timegm(0,0,0,$mday,$mon-1,$year-1900);

        $data_sended=fileLib::toSql($data_sended_gm);

        $data_base::db->do("INSERT INTO xml (pointid, data_sended) VALUES(?,?) "
        ,{}, ($point_id,$data_sended) );
    }


    return fileLib::toUnix($data_sended);
}
#------------------------------------------------------
# getDatetimeActual
#------------------------------------------------------
sub getDatetimeActual {
    my ($point_id)=@_;

    my ($cur_actual) = data_base::SQLrow("SELECT data_actual FROM points WHERE id=CAST( ? AS UNSIGNED);",[$point_id]);
    my $cur_actual_gm;
    if (substr($cur_actual,0,4) eq "0000")
    {
       $cur_actual_gm=0;
    }
    else
    {
       $cur_actual_gm=fileLib::toUnix($cur_actual);
    }

    return $cur_actual_gm;
}
#------------------------------------------------------
# serveAll
#------------------------------------------------------
sub serveAll {

    for my $point_id (parameters::points()) 
    {
        my $set=parameters::point($point_id);

#        my $data_xml_sftp_enable = $$set{data_xml_sftp_enable};
#        my $data_xml_sftp_send_point_id = $$set{data_xml_sftp_send_point_id};
#        my $data_xml_sftp_send_period = $$set{data_xml_sftp_send_period};
#        my @data_xml_sftp_carpass_max = @{$$set{data_xml_sftp_carpass_max}};

        next unless $parameters::data_xml_sftp_enable;

        print "data_xml_sftp_enable=$parameters::data_xml_sftp_enable\n";
        print "data_xml_sftp_send_point_id=$parameters::data_xml_sftp_send_point_id\n";
        print "data_xml_sftp_send_period=$parameters::data_xml_sftp_send_period\n";
        print "data_xml_sftp_carpass_max=",::dump(\@parameters::data_xml_sftp_carpass_max),"\n";

        my $data_sended=getSendDatetime($point_id);
        my $cur_actual_gm=getDatetimeActual($point_id);

        print "data_sended=",fileLib::toSql($data_sended),"\n";
        print "cur_actual_gm=",fileLib::toSql($cur_actual_gm),"\n";

        my $data_send=$data_sended+$parameters::data_xml_sftp_send_period;

        next if $cur_actual_gm<$data_send;

        print "data_send=",fileLib::toSql($data_send),"\n";

        data_xml_sftp::data_init($data_sended);

        dataSave($point_id,fileLib::toSql($data_sended),fileLib::toSql($data_send));

        data_xml_sftp::data_saveFile();

    }

    return;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {

#    $parameters::tempFileDir='F:\prg_perl\_ru_cheb\web_mashine';
#    $parameters::tempFileDir='D:\prg_perl\_ru_cheb\web_mashine';

    data_base::init();

    parameters::init();

#    print ::dump(\%settings::_data);
#    print $settings::_script,"\n";
#    die;

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
