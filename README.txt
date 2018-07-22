
Run : vagrant plugin install vagrant-vbguest
This plugin enables files transfer to salt minion during provisioning.

Verify /etc/pki/tls/openssl.cnf was update with logstash server IP:
[ v3_ca ]

# Server IP Address
subjectAltName = IP: <IP_Address>

Filebeat client needs some manual setup since we don't know the server IP during provisioning. In the "real world", we can keep server IP in some database, extract it and using during client installation:

Login to the ELK server. Then copy the certificate file from the elastic server to the client server:
ssh root@client_IP
scp root@elk-server_IP:~/logstash-forwarder.crt .
TYPE elk-server password
sudo mkdir -p /etc/pki/tls/certs/
mv ~/logstash-forwarder.crt /etc/pki/tls/certs/

Modify /etc/filebeat/filebeat.yml with correct elk-server_IP:
# The Logstash hosts
  hosts: ["10.0.15.10:5443"]
  
Restart filebeat service:
systemctl restart filebeat



