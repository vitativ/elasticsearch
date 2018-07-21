# Setup Elastic Repo
{% from "kibana/map.jinja" import kibana with context %}

kibana-repo:
  pkgrepo.managed:
    - humanname: Kibana Repo
{%- if grains.get('os_family') == 'Debian' %}
    - name: deb {{ kibana.repo_url }} stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - gpgcheck: 1
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch
    - require_in:
      - pkg: kibana
    - clean_file: true
{%- elif grains['os_family'] == 'RedHat' %}
    - name: kibana
	- baseurl: {{ kibana.repo_url }}/yum
	- enabled: 1
    - gpgcheck: 1
    - gpgkey: http://artifacts.elastic.co/GPG-KEY-elasticsearch
{%- endif %}
