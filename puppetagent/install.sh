#!/bin/bash

# Puppet master
yum install puppet
puppet resource package ensure=latest
#/etc/init.d/puppet restart

cat << HOSTS_FILE >> /etc/hosts
192.168.33.5 master puppet
192.168.33.10 nodea
192.168.33.20 nodeb
192.168.33.30 nodec
192.168.33.40 bart
192.168.33.100 vip
192.168.33.101 haproxyvip 
HOSTS_FILE

cat << PUPPET_CONF > /etc/puppet/puppet.conf
[main]
    # The Puppet log directory.
    # The default value is '$vardir/log'.
    logdir = /var/log/puppet

    # Where Puppet PID files are kept.
    # The default value is '$vardir/run'.
    rundir = /var/run/puppet

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl
    server = master

[agent]
    # The file in which puppetd stores a list of the classes
    # associated with the retrieved configuratiion.  Can be loaded in
    # the separate ``puppet`` executable using the ``--loadclasses``
    # option.
    # The default value is '$confdir/classes.txt'.
    classfile = $vardir/classes.txt

    # Where puppetd caches the local configuration.  An
    # extension indicating the cache format is added automatically.
    # The default value is '$confdir/localconfig'.
    localconfig = $vardir/localconfig
PUPPET_CONF 
