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
    },
    {
      :name => 'nodeb1',
      :addr => '192.168.33.25',
      :data => './puppetagent',
    },
    {
      :name => 'nodec1',
      :addr => '192.168.33.35',
      :data => './puppetagent',
    },
    {
      :name => 'noded1',
      :addr => '192.168.33.45',
      :data => './puppetagent',
    },
    {
      :name => 'barman1',
      :addr => '192.168.33.95',
      :data => './puppetagent',
    },
  ]

  nodes.each_with_index do | node, i |
    global.vm.define node[:name] do | config |
      config.vm.hostname = node[:name]
      config.vm.network :private_network,
        ip: node[:addr],
        virtualbox_inet: true
      config.vm.synced_folder node[:data], '/scripts'
      config.vm.provision "shell",
        inline: "/vagrant/install.sh #{i+1} #{nodes.length}"
    end
  end

end
