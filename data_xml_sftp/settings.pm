#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;

    package settings;
#------------------------------------------------------

    use vars qw($point_code $run_number $server_url);
    use vars qw($com_port $com_port_adres $com_port_port);
    use vars qw($com_port_linux_file $com_port_speed);
    use vars qw($pribor @dev_adress);

    use vars qw($data_xml_sftp_enable);
    use vars qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    use vars qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);
    
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# loadSet
#------------------------------------------------------
    sub loadSet {
        my ($file)=@_;

        do "lib/settings_base.pl";
        do $file;

        return;
    }
#------------------------------------------------------
1;
