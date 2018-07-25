{% from "map.jinja" import common_pkgs with context %}

install packages1:
  pkg.installed:
    - pkgs:
      - {{ common_pkgs.nginx }}
      - {{ common_pkgs.httpd_tools }}

remove default virtual host:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx.conf
    - makedirs: True

/etc/nginx/conf.d/kibana.conf:
  file.append:
    - text: |
        server {
        	listen 8080 default_server;

            auth_basic "Restricted Access";
            auth_basic_user_file /etc/nginx/.kibana-user;

            location / {
                proxy_pass http://localhost:5601;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
            }
        }

admin:
  webutil.user_exists:
    - password: kibana
    - htpasswd_file: /etc/nginx/.kibana-user
    - options: d
    - force: true
    - require:
      - pkg: install packages1

start_nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install packages1

/etc/ssh/sshd_config:
  file.replace:
    - pattern: PasswordAuthentication no
    - repl: PasswordAuthentication yes

sshd:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config
