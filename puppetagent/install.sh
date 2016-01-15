#!/bin/bash

cat << HOSTS_FILE >> /etc/hosts
192.168.33.5 puppet puppetmaster puppet-master-91.control.net
HOSTS_FILE

mkdir -p /etc/puppetlabs/facter/facts.d
cat <<EOF > /etc/puppetlabs/facter/facts.d/host.yaml
network_location: zone1
puppet_role: postgresHA
application_environment: development
hosting_platform: vagrant
EOF

#sed -i "s/\[agent\]/\[agent\]\nenvironment = local/" /etc/puppet/puppet.conf 
echo "environment = local" >> /etc/puppet/puppet.conf

puppet agent --test --waitforcert 10

