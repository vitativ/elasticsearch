{% from "map.jinja" import common_pkgs with context %}

install logstash:
  cmd.run:
    - name: |
        wget https://artifacts.elastic.co/downloads/logstash/{{ common_pkgs.logstash }}
        rpm -ivh {{ common_pkgs.logstash }}

#{% set server_ip =  salt['mine.get']('*','network.ip_addrs') %}
#{% set server_ip = grains['ipv4'][0] %}
{% set server_ip = grains['ip_interfaces']['eth1'][0] %}
/etc/pki/tls/openssl.cnf:
  file.blockreplace:
    - marker_start: "[ v3_ca ]"
    - marker_end: "# Extensions for a typical CA"
    - content: "subjectAltName = IP: {{ server_ip }}"

generate cert file:
  cmd.run:
    - name: openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out   /etc/pki/tls/certs/logstash-forwarder.crt

/etc/logstash/conf.d/filebeat-input.conf:
  file.managed:
    - contents: |
        input {
          beats {
            port => 5443
            ssl => true
            ssl_certificate => "/etc/pki/tls/certs/logstash-forwarder.crt"
            ssl_key => "/etc/pki/tls/private/logstash-forwarder.key"
          }
        }

/etc/logstash/conf.d/syslog-filter.conf:
  file.managed:
    - contents: |
        filter {
          if [type] == "syslog" {
            grok {
              match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
              add_field => [ "received_at", "%{@timestamp}" ]
              add_field => [ "received_from", "%{host}" ]
            }
            date {
              match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
            }
          }
        }

/etc/logstash/conf.d/output-elasticsearch.conf:
  file.managed:
    - contents: |
        output {
          elasticsearch { hosts => ["localhost:9200"]
            hosts => "localhost:9200"
            manage_template => false
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
          }
        }

logstash:
  service.running:
    - enable: True