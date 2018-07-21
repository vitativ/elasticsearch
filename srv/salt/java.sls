{% from "map.jinja" import common_pkgs with context %}

install common_packages:
  pkg.installed:
    - pkgs:
      - {{ common_pkgs.java }}