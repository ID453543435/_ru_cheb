#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
#    use Win32::SerialPort;
    use com_port;
    use strict;
    use rtu;
#------------------------------------------------------
    package tranfer;

#    use vars qw($comPort);
#------------------------------------------------------
# null
#------------------------------------------------------
    sub null {
        my ($par)=@_;


        return $par;
    }
#------------------------------------------------------
# printData
#------------------------------------------------------
    sub printData {
        my ($data)=@_;

        $data =~ s/(.)/sprintf("|%02x",ord($1))/esg; print "$data\n";
       
        return;
    }
#------------------------------------------------------
# openPort
#------------------------------------------------------
    sub openPort {
        
        com_port::openPort();

        return;
    }
#------------------------------------------------------
# closePort
#------------------------------------------------------
    sub closePort {

        com_port::closePort();

        return;
    }
#------------------------------------------------------
# sendData
#------------------------------------------------------
    sub sendData {
        my ($data)=@_;

        print ">";printData($data);

        my $crc16=rtu::crc($data);
        $data=$data.pack("n",$crc16);

        $data =~ s{\x7D}{\x7D\x5D}sg; 
        $data =~ s{\x7E}{\x7D\x5E}sg; 

        $data = "\x7E".$data."\x7E";

#        $data =~ s/(.)/sprintf("|%02x",ord($1))/eg; print "$data\n";die;

        my $count_out = com_port::sendData($data);
        warn "write failed\n"         unless ($count_out);
        warn "write incomplete\n"     if ( $count_out != length($data) );  

#        sleep(0.1);

        return;
    }
#------------------------------------------------------
# readData
#------------------------------------------------------
    sub readData {

        my $data=readPacket();

        my $crc=unpack("n",substr($data,-2,2));

        $data=substr($data,0,-2);

        my $crc16=rtu::crc($data);


        if ($crc !=$crc16)
        {
           print "\nCRC error!\n";
           
        }

        print "<";printData($data);

        return $data;
    }
#------------------------------------------------------
# readPacket
#------------------------------------------------------
    sub readPacket {

        my $data="";

        my $fallCount=5;
        my $mode=0;
        while (1)
        {
           my ($count_in, $string_in) = com_port::readData(1);
           if ($count_in != 1)
           {
#               print "\nread fall:count_in=$count_in,string_in=$string_in\n";
               unless (--$fallCount)
               {
                  print "\nread fall:timeout\n";
                  last;
               };
               sleep(1); next;
           }
           if ($mode==0)
           {
              if ($string_in eq "\x7E")
              {
                 $mode=1;
              }

           }
           elsif ($mode==1)
           {
              if ($string_in eq "\x7E")
              {
                 last;
              }
              elsif ($string_in eq "\x7D")
              {
                 $mode=2;
                 next;
              }
              $data .= $string_in;
           }
           elsif ($mode==2)
           {
#              print "*";
              $data .= pack("C",unpack("C",$string_in) | 0x20);

              $mode=1;
           }
           else
           {
              die;
           }
        }

#        sleep(0.1);

        return $data;
    }
#------------------------------------------------------
1;
