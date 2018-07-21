{%- from 'logstash/map.jinja' import logstash with context %}

{%- if logstash.use_upstream_repo %}
include:
  - .repo
{%- endif %}

logstash-pkg:
  pkg.{{logstash.pkgstate}}:
    - name: {{logstash.pkg}}
    {%- if logstash.use_upstream_repo %}
    - require:
      - pkgrepo: logstash-repo
      - pkg: {{ logstash.java }}
    {%- endif %}

{{ logstash.java }}:
  pkg.installed

{% set server_ip =  salt['mine.get']('network.ip_addrs') %}
/etc/pki/tls/openssl.cnf:
  file.line:
    - mode: ensure
    - content: subjectAltName = IP: {{ server_ip }}
    - after: [ v3_ca ]
	- require:
      - pkg: logstash-pkg
	
generate cert file:
  cmd.run:
    - name: openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out  /etc/pki/tls/certs/logstash-forwarder.crt
	- require:
      - pkg: logstash-pkg
	  - file: /etc/pki/tls/openssl.cnf
	
  
{%- if logstash.inputs is defined %}
logstash-config-inputs:
  file.managed:
    - name: /etc/logstash/conf.d/filebeat-input.conf
    - source: salt://logstash/files/01-inputs.conf
    - template: jinja
    - require:
      - pkg: logstash-pkg
{%- else %}
logstash-config-inputs:
  file.absent:
    - name: /etc/logstash/conf.d/filebeat-input.conf
{%- endif %}

{%- if logstash.filters is defined %}
logstash-config-filters:
  file.managed:
    - name: /etc/logstash/conf.d/syslog-filter.conf
    - source: salt://logstash/files/02-filters.conf
    - template: jinja
    - require:
      - pkg: logstash-pkg
{%- else %}
logstash-config-filters:
  file.absent:
    - name: /etc/logstash/conf.d/syslog-filter.conf
{%- endif %}

{%- if logstash.outputs is defined %}
logstash-config-outputs:
  file.managed:
    - name: /etc/logstash/conf.d/output-elasticsearch.conf
    - source: salt://logstash/files/03-outputs.conf
    - template: jinja
    - require:
      - pkg: logstash-pkg
{%- else %}
logstash-config-outputs:
  file.absent:
    - name: /etc/logstash/conf.d/output-elasticsearch.conf
{%- endif %}

logstash-svc:
  service.running:
    - name: {{logstash.svc}}
    - enable: true
    - require:
      - pkg: logstash-pkg
    - watch:
      - file: logstash-config-inputs
      - file: logstash-config-filters
      - file: logstash-config-outputs
