#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use parameters;
    
    package settings;
#------------------------------------------------------

=head1 SYNOPSIS

    use vars qw($point_code $run_number $server_url);
    use vars qw($com_port $com_port_adres $com_port_port);
    use vars qw($com_port_linux_file $com_port_speed);
    use vars qw($pribor @dev_adress);

    use vars qw($data_xml_sftp_enable);
    use vars qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    use vars qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);
=cut
    
    use vars qw(@_vars);

    @_vars=();
    push @_vars, qw($point_code $run_number $server_url);
    push @_vars, qw($com_port $com_port_adres $com_port_port);
    push @_vars, qw($com_port_linux_file $com_port_speed);
    push @_vars, qw($pribor @dev_adress);

    push @_vars, qw($data_xml_sftp_enable);
    push @_vars, qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    push @_vars, qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);

    use vars @_vars;

    use vars qw(%_data);

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
# saveCurrent
#------------------------------------------------------
    sub saveCurrent {
        my ($pointId)=@_;

        $_data{$pointId}={};
        for my $i (@_vars)
        {



#           $$_data{$pointId}{$i}=

        }


        return;
    }
#------------------------------------------------------
# dirList
#------------------------------------------------------
sub dirList {
    my ($dirname)=@_;

    opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
    my @files = readdir $dh;
    closedir $dh;

#    print ::dump(\@files),":dirList\n";

#    shift @files; 
#    shift @files; 
    @files = grep(not( m{^\.\.?$}s), @files);
    
    return \@files;
}
#------------------------------------------------------
# init
#------------------------------------------------------
    sub init {

        my $dir=$parameters::tempFileDir.'/settings/';
        my $list=dirList($dir);

        for my $file (@$list)
        {
            my $fileSet=$dir.$file.'/current/settings.pl';
            if (-f($fileSet))
            {
               print "$fileSet\n";

            }
        }

        return;
    }
#------------------------------------------------------
1;
