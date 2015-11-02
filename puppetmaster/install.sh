#!/bin/bash

# Puppet master
yum install puppet-server
puppet resource package-server ensure=latest
#/etc/init.d/puppetmaster restart

hostname master
echo 'master' > /etc/hostname
echo '192.168.33.5 master' >> /etc/hosts 

# Start puppet master service
#puppet master
