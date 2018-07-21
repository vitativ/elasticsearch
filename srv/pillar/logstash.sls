logstash:
  java: java-1.8.0-openjdk-devel
  use_upstream_repo: True
  repo:
    version: major or minor version number
    old_repo: False
  inputs:
    plugin_name: file
    path:
      - /var/log/secure
      - /var/log/messages
    type: syslog
  filters:
    plugin_name: grok
    cond: 'if [type] == "syslog"'
    match:
      message: '%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}'
    add_field:
      received_at: '%{@timestamp}'
      received_from: '%{host}'
    plugin_name: date
    match:
      - 'syslog_timestamp'
      - 'MMM  d HH:mm:ss'
      - 'MMM dd HH:mm:ss'
  outputs:
    plugin_name: elasticsearch
    hosts:
      - localhost:9200
      - manage_template: false
	index:
      - '%{[@metadata][beat]}-%{+YYYY.MM.dd}'
    document_type: "%{[@metadata][type]}"