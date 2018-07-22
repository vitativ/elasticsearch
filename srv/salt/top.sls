base:
  'roles:server':
    - match: grain
    - java
    - elasticsearch
    - kibana
    - epel
    - nginx
    - logstash
  'roles:client':
    - match: grain
    - filebeat