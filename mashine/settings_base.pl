$server_url="http://94.232.56.19:8080/cgi-bin/web_mashine/";
#===============================
$com_port="tcp_win";  
# "win", "linux", "tcp", "tcp_win", "tcp_win_reconnect", 
# "radar" (tcp_win_reconnect+ $pribor="pribor"), "radar_cl" (linux+ $pribor="pribor")

#  $com_port="tcp", "tcp_win", "tcp_win_reconnect" settings:
$com_port_adres="192.168.1.1";
$com_port_port=503;

#  $com_port="linux" settings:
$com_port_linux_file="/dev/ttyAMA0";
$com_port_speed=115200;

#  $com_port="radar" settings:
$radar_adres="213.87.81.32";
$radar_port=2001;

#===============================
$pribor="pribor"; # "pribor", "radar", "radar_old"

#  $pribor="pribor" settings:
@dev_adress=(0x01);

#===============================
$data_xml_sftp_enable=0;

$data_xml_sftp_adress="95.53.129.30";
$data_xml_sftp_port="3058";
$data_xml_sftp_user="novgufa";
$data_xml_sftp_password="NNovUf536";

$data_xml_sftp_send_point_id=777;
$data_xml_sftp_send_period=60*60;
@data_xml_sftp_carpass_max=(9999,9999,9999,9999,9999,9999,9999,9999,9999);
