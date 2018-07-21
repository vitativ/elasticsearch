# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "kibana/map.jinja" import kibana with context %}
include:
  - kibana.install

# We directly serialize the config subtree into the YAML file.
kibana-config:
  file.serialize:
    - name: {{ kibana.configfile }}
    - dataset: {{ kibana.config }}
    - formatter: "YAML"
    - require:
      - sls: kibana.install
