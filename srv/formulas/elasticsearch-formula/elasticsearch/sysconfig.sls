include:
  - elasticsearch.service

{% if grains.get('os_family') == 'Debian' %}
{% set sysconfig_file = '/etc/default/elasticsearch' %}
{% else %}
{% set sysconfig_file = '/etc/sysconfig/elasticsearch' %}
{% endif %}

{%- if salt['pillar.get']('elasticsearch:sysconfig') %}
elasticsearch_syscfg:
  file.serialize:
    - name: {{ sysconfig_file }}
    - dataset_pillar: elasticsearch:sysconfig
    - formatter: yaml
    - user: root
    - require:
      - sls: elasticsearch.pkg
{%- endif %}
