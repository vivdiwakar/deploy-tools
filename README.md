# deploy-tools
Deployment scripts run using Puppet (local) on an Ubuntu-based host.

### Installation ###
```
$ wget -c "https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb" -O /tmp
$ sudo dpkg -i /tmp/puppetlabs-release-pc1-xenial.deb 
$ sudo apt-get update 
$ sudo apt-get install puppet-agent 
```

### Usage ###
```
$ puppet apply /path/to/install_<PACKAGE>.pp
```

