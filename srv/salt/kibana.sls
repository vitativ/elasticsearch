{% from "map.jinja" import common_pkgs with context %}

install packages:
  pkg.installed:
    - pkgs:
      - {{ common_pkgs.wget }}

install kibana:
  cmd.run:
    - name: |
        wget https://artifacts.elastic.co/downloads/kibana/{{ common_pkgs.kibana }}
        rpm -ivh {{ common_pkgs.kibana }}

/etc/kibana/kibana.yml:
  file.managed:
    - contents: |
        server.port: 5601
        server.host: "localhost"
        elasticsearch.url: "http://localhost:9200"	

kibana:
  service.running:
    - enable: True