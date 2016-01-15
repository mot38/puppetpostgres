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
      :name => 'nodea',
      :addr => '192.168.33.10',
      :data => './puppetagent',
    },
    {
      :name => 'nodeb',
      :addr => '192.168.33.20',
      :data => './puppetagent',
    },
    {
      :name => 'nodec',
      :addr => '192.168.33.30',
      :data => './puppetagent',
    },
    {
      :name => 'noded',
      :addr => '192.168.33.90',
      :data => './puppetagent',
    },
    {
      :name => 'barman',
      :addr => '192.168.33.40',
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
