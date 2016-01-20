# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do | global |
  global.vm.box = "landregistry/centos"
  global.vm.provision "shell", inline: 'sudo yum update -q -y'

  nodes = [
    {
      :name => 'puppetmaster',
      :addr => '192.168.33.5',
      :data => './puppetmaster',
    },
    {
      :name => 'nodea1',
      :addr => '192.168.33.15',
      :data => './puppetagent',
      :role =>  'postgresqlha_master',
    },
    {
      :name => 'nodeb1',
      :addr => '192.168.33.25',
      :data => './puppetagent',
      :role => 'postgresqlha_standby',
    },
    {
      :name => 'nodec1',
      :addr => '192.168.33.35',
      :data => './puppetagent',
      :role => 'postgresqlha_standby',
    },
    {
      :name => 'noded1',
      :addr => '192.168.33.45',
      :data => './puppetagent',
      :role => 'postgresqlha_standby',
    },
    {
      :name => 'barman1',
      :addr => '192.168.33.95',
      :data => './puppetagent',
      :role => 'barman',
    },
  ]

  nodes.each do | node |
    global.vm.define node[:name] do | config |
      config.vm.hostname = node[:name]
      config.vm.network :private_network,
        ip: node[:addr],
        virtualbox_inet: true
      config.vm.synced_folder node[:data], '/scripts'
      config.vm.provision "shell",
        inline: "/vagrant/install.sh #{node[:role]}"
    end
  end

end
