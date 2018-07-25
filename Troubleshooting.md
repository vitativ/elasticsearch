# Troubleshooting:

1. Login to ELKstack machine:
		
		Verify /etc/pki/tls/openssl.cnf was update with ELKstack machine IP at [v3_ca] section
		[ v3_ca ]
		## Server IP Address
		subjectAltName = IP: 192.168.30.10
		If not,update and restart logstash service: systemctl restart logstash

2. The listening port at /etc/nginx/conf.d/kibana.conf should be identical to the one defined in 
   ELKstack Vagrantfile.

3. Verify on ELKstack machine that the following ports are listening (netstat -plntu): 9200, 5601, 8080, 5443

4. If nginx service is not running and http port is not listening

		Verify SElinux is disabled on server:
			cat /etc/sysconfig/selinux:
			SELINUX=disabled
		If not, update the file and reboot the machine

5. If "Unable to fetch mapping" issue occurs while creating new index in Kibana, check the following logs:
   
		On teh client /var/log/filebeat/filebeat
		On the server /var/log/logstash/logstash-plain.log
