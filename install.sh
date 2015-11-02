#!/bin/bash

# Check running as root
if [ $(id -u) != '0' ]; then
  echo "You must run $0 as root!"
  exit 1
fi

# NTP time sync
ntpdate pool.ntp.org

# Puppet install - already done on landregistry/centos
# rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

# Type-specific installation
echo "Installing configuration specific to $(hostname)"
/scripts/install.sh $1

