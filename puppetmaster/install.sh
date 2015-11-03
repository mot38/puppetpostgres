#!/bin/bash

# Puppet master
sudo yum install puppet-server
puppet resource package ensure=latest
#/etc/init.d/puppetmaster restart

hostname puppet
echo 'puppet' > /etc/hostname
echo '192.168.33.5 master' >> /etc/hosts 

# Start puppet master service
puppet master
