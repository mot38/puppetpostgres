#!/bin/bash

yum install -y git ruby-devel
cd /vagrant/puppet-control
rm -rf Puppetfile.lock
gem install librarian-puppet --no-ri --no-rdoc
ln -s /usr/local/bin/librarian-puppet /usr/bin/librarian-puppet
librarian-puppet install
sed -i "s/\$confdir/\/etc\/puppet/" /vagrant/puppet-control/site/profiles/manifests/puppet/master.pp
puppet apply --modulepath=site:modules site/profiles/tests/puppet/master.pp
cp /vagrant/puppet-control/site/profiles/files/hiera.yaml /etc/puppet/
ln -s /usr/local/bin/r10k /usr/bin/r10k
r10k deploy environment
ln -s /vagrant/puppet-control /etc/puppet/environments/local
sed -i "s/\[agent\]/\[agent\]\nenvironment = local/" /etc/puppet/puppet.conf
