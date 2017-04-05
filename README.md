# deploy-tools
Deployment scripts run using Puppet (local) on an Ubuntu-based host.

### Installation ###
```
$ wget -c "https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb" -O /tmp/puppetlabs-release-pc1-xenial.deb 
$ sudo dpkg -i /tmp/puppetlabs-release-pc1-xenial.deb 
$ sudo apt-get update 
$ sudo apt-get install puppet-agent 
```

### Update paths and verify ###
```
$ sed -e 's/\(.* PATH=.*\)/\1:\/opt\/puppetlabs\/bin/g' -i.bak.`date +%Y%m%d` ~/.bashrc
$ . ~/.bashrc
$ puppet help | grep \^Puppet 
Puppet v4.9.4
```

### Usage ###
```
$ sudo puppet apply /path/to/clone/<PACKAGE>/install_<PACKAGE>.pp
```

