# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "kibana/map.jinja" import kibana with context %}

{%- if kibana.source %}
include:
  - kibana.source
{%- else %}
{%- if kibana.use_upstream_repo %}
include:
  - kibana.repo
{%- endif %}

kibana-pkg:
  pkg.installed:
    - name: {{ kibana.pkg }}
{%- if kibana.repoVersion.startswith('5.') %}
    - version: {{ kibana.repoVersion }}
{% endif %}
{%- endif %}
