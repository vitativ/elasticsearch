include:
  - elasticsearch.pkg

{%- if salt['pillar.get']('elasticsearch:config') %}
elasticsearch_cfg:
  file.serialize:
    - name: /etc/elasticsearch/elasticsearch.yml
    - dataset_pillar: elasticsearch:config
    - formatter: yaml
    - user: root
    - require:
      - sls: elasticsearch.pkg
{%- endif %}

