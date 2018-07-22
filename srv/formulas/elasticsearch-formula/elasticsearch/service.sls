include:
  - elasticsearch.pkg
  - elasticsearch.config

/usr/lib/systemd/system/elasticsearch.service:
  file.uncomment:
    - regex: LimitMEMLOCK=infinity

update-systemd:
  cmd.run:
    - name: systemctl daemon-reload

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
{%- if salt['pillar.get']('elasticsearch:config') %}
    - watch:
      - file: elasticsearch_cfg
{%- endif %}
    - require:
      - pkg: elasticsearch
