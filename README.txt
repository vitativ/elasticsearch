
Run : vagrant plugin install vagrant-vbguest
This plugin enables files transfer to salt minion during provisioning.

Machines setup:
1. Create new folder for ELK server vm called "ELKstack"
2. Copy the content of this repo into the ELKstack folder
3. Rename Vagrantfile_server to Vagrantfile
4. Run "vagrant up" in command line while prompted to ELKstack folder

5. Create new folder for filebeat client vm called "Filebeat_client1"
6. Copy the content of this repo into the Filebeat_client1 folder
7. Rename Vagrantfile_client to Vagrantfile
8. Run "vagrant up" in command line while prompted to Filebeat_client1 folder

----------------------------------------------------------------------------------------------------------------------
Filebeat client needs some manual setup since we don't know what the ELKstack server IP would be, so we can't use
it during client provisioning. 
In the "real world", we can keep server IP in some database, extract it and use during client provisioning:

Login to the ELKstack server. Copy the certificate file from the ELKstack server to the Filebeat client:
ssh root@Filebeat_client1_IP
scp root@ELKstack_IP:~/logstash-forwarder.crt .
TYPE ELKstack server password
sudo mkdir -p /etc/pki/tls/certs/
mv ~/logstash-forwarder.crt /etc/pki/tls/certs/

Modify /etc/filebeat/filebeat.yml with correct ELKstack_IP:
# The Logstash hosts
  hosts: ["ELKstack_IP:5443"]
  
Restart filebeat service:
systemctl restart filebeat
---------------------------------------------------------------------------------------------------------------------
Bombing the logs file:
Run logger_bombing.sh from /vagrant on Filebeat client machine.

Go to :
http://<ELK-server-IP>:8080/app/kibana
And see the logs comming in.


