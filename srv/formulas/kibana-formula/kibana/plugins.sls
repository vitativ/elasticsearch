{% from "kibana/map.jinja" import kibana with context %}


{%- set plugins_list = salt['pillar.get']('kibana:plugins', {}) %}

{% if kibana.source  %}
    {%- set install_path = kibana.sources.installPath ~ 'current' %}
    {% if kibana.sourceVersion[0] == '5' %}
        {%- set plugin_bin = 'kibana-plugin' %}
    {% else %}
        {%- set plugin_bin = 'plugin' %}
    {% endif %}
{% else %}
    {%- set install_path = '/usr/share/kibana' %}
    {% if kibana.repoVersion == '5' %}
        {%- set plugin_bin = 'kibana-plugin' %}
    {% else %}
        {%- set plugin_bin = 'plugin' %}
    {% endif %}
{% endif %}

include:
    - kibana.install

{% for name, repo in plugins_list.items() %}
kibana-plugin-{{ name }}:
    cmd.run:
        - name: {{ install_path }}/bin/{{ plugin_bin }} install -b {{ repo }}
        - require:
            - sls: kibana.install
        - unless: test -x {{ install_path }}/plugins/{{ name }}
{% endfor %}
