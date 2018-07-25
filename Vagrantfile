# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "server", primary: true do |server|
    server.vm.hostname = "server"
    server.vm.box = "centos/7"
    server.vm.network "forwarded_port", guest: 8080, host: 8080
    server.vm.network "private_network", ip: "192.168.30.10"
    server.vm.provider "virtualbox" do |vb|
       vb.memory = "4096"
    end

    server.vm.synced_folder "srv/salt/", "/srv/salt/"
    server.vm.synced_folder "srv/pillar/", "/srv/pillar/"
    server.vm.synced_folder "srv/formulas/", "/srv/formulas/"

    server.vm.provision :salt do |salt|
      salt.minion_config = "srv/salt/minion_server.yml"
      salt.run_highstate = true
      salt.colorize = true
      salt.log_level = 'debug'
    salt.verbose = true
    end
  end

  config.vm.define "client" do |client|
    client.vm.hostname = "client"
    client.vm.box = "centos/7"
    client.vm.network "private_network", ip: "192.168.30.11"
    client.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
    end

    client.vm.synced_folder "srv/salt/", "/srv/salt/"

    client.vm.provision :salt do |salt|
      salt.minion_config = "srv/salt/minion_client.yml"
      salt.run_highstate = true
      salt.colorize = true
      salt.log_level = 'debug'
    salt.verbose = true
    end
  end

end
