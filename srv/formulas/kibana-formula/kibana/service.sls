# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "kibana/map.jinja" import kibana with context %}

kibana-name:
  service.running:
    - name: {{ kibana.service.name }}
    - enable: True
