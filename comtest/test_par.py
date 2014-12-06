#------------------------------------------------------
#sftp://95.53.129.30:3058
#login: novgufa
#pass: NNovUf536
#------------------------------------------------------
#import pysftp
import paramiko
#------------------------------------------------------
def main():
#   sftpCon=pysftp.Connection('95.53.129.30:3058', username='novgufa', password='NNovUf536')
   sftp_server="95.53.129.30"
   sftp_port=3058
   sftp_login="novgufa"
   password="NNovUf536"
   transport = paramiko.Transport((sftp_server, sftp_port))
   transport.connect(username = sftp_login, password = sftp_password)
   sftp = paramiko.SFTPClient.from_transport(transport)
#   sftp.get("file_name", '.', None)
   files = sftp.listdir()
   print(files)   

#------------------------------------------------------
main()
