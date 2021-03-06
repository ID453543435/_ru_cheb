#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use strict;
    use fileLib;
    use parameters;
    
    package parameters;
#------------------------------------------------------

#=head1 SYNOPSIS

    use vars qw($point_code $run_number $server_url);
    use vars qw($com_port $com_port_adres $com_port_port);
    use vars qw($com_port_linux_file $com_port_speed);
    use vars qw($pribor @dev_adress);

    use vars qw($data_xml_sftp_enable);
    use vars qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    use vars qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);
#=cut
    
    use vars qw(@_vars);

    @_vars=();
    push @_vars, qw($point_code $run_number $server_url);
    push @_vars, qw($com_port $com_port_adres $com_port_port);
    push @_vars, qw($com_port_linux_file $com_port_speed);
    push @_vars, qw($pribor @dev_adress);

    push @_vars, qw($data_xml_sftp_enable);
    push @_vars, qw($data_xml_sftp_adress $data_xml_sftp_port $data_xml_sftp_user $data_xml_sftp_password);
    push @_vars, qw($data_xml_sftp_send_point_id $data_xml_sftp_send_period @data_xml_sftp_carpass_max);

#    use vars @_vars;

    use vars qw(%_data $_script $_script_from);
    $_script=generate(\@_vars);
    $_script_from=generateFrom(\@_vars);

#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# points
#------------------------------------------------------
    sub points {

        return keys(%_data);
    }
#------------------------------------------------------
# point
#------------------------------------------------------
    sub point {
        my ($id)=@_;

        my %a=%{$_data{0+$id}};

        eval($_script_from);

        return;
    }
#------------------------------------------------------
# generate
#------------------------------------------------------
    sub generate {
        my ($list)=@_;

        my $res="";

        for my $i (@$list)
        {
           my $type=substr($i,0,1);
           my $name=substr($i,1);
           if ($type eq '$')
           {
              $res .= "$name => $i ,\n";
           } 
           elsif ($type eq '@')
           {
              $res .= "$name => [$i] ,\n";
           } 
           elsif ($type eq '%')
           {
              $res .= "$name => {$i} ,\n";
           } 


        }


        return "{ $res }";
    }
#------------------------------------------------------
# generateFrom
#------------------------------------------------------
    sub generateFrom {
        my ($list)=@_;

        my $res="";

        for my $i (@$list)
        {
           my $type=substr($i,0,1);
           my $name=substr($i,1);
           if ($type eq '$')
           {
              $res .= "$i=\$a{$name};\n";
           } 
           elsif ($type eq '@')
           {
              $res .= "$i=\@{\$a{$name}};\n";
           } 
           elsif ($type eq '%')
           {
              $res .= "$i=\%{\$a{$name}};\n";
           } 
        }

        return $res;
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

        $_data{$pointId}=eval($_script);

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
               loadSet($fileSet);
               saveCurrent(0+$file);

            }
        }

        return;
    }
#------------------------------------------------------
1;
