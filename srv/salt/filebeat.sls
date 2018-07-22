{% from "map.jinja" import common_pkgs with context %}

install packages:
  pkg.installed:
    - pkgs:
      - {{ common_pkgs.wget }}

import elastic key:
  cmd.run:
    - name: rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

install filebeat:
  cmd.run:
    - name: |
        wget https://artifacts.elastic.co/downloads/beats/filebeat/{{ common_pkgs.filebeat }}
        rpm -ivh {{ common_pkgs.filebeat }}

/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://files/filebeat.yml
    - makedirs: True

filebeat:
  service.running:
    - enable: True