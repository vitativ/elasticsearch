elasticsearch:
  version: 5.1.1
  use_repo: True
  config:
    bootstrap.memory_lock: true
    network.host: localhost
    http.port: 9200
  sysconfig:
    MAX_LOCKED_MEMORY=unlimited
