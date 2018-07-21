# Install Kibana from source
{% from "kibana/map.jinja" import kibana with context %}

{% if grains['osarch'] == 'amd64' %}
{% set kibanaArchitecture = 'x64' %}
{% else %}
{% set kibanaArchitecture = 'x86' %}
{% endif %}

make-sure-kibana-opt-dir-exists:
  file.directory:
    - name: {{kibana.sources.installPath}}

setup-kibana-sources-linux:
  archive.extracted:
    - name: {{kibana.sources.installPath}}
    - source: {{kibana.sources.baseURL}}kibana-{{kibana.sourceVersion}}-linux-{{ kibanaArchitecture }}.tar.gz
    - source_hash: {{kibana.sources.baseURL}}kibana-{{kibana.sourceVersion}}-linux-{{ kibanaArchitecture }}.tar.gz.sha1.txt
    - archive_format: tar
    - if_missing: {{kibana.sources.installPath}}kibana-{{kibana.sourceVersion}}-linux-{{ kibanaArchitecture }}
  file.symlink:
    - name: {{kibana.sources.installPath}}current
    - target: {{kibana.sources.installPath}}kibana-{{kibana.sourceVersion}}-linux-{{ kibanaArchitecture }}
