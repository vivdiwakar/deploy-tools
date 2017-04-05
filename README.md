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
$ target=/home/${USER}/.bashrc
$ grep -w PATH= ${target} 2> /dev/null > /dev/null ; if [ ${?} -ne 0 ] ; then echo -e "export PATH=${PATH}" >> ${target} ; fi
$ sed -e 's/\(.* PATH=.*\)/\1:\/opt\/puppetlabs\/bin/g' -i.bak.`date +%Y%m%d` ${target}
$ . ${target}
$ puppet help | grep \^Puppet 
Puppet v4.9.4
$ facter -v
3.6.2 (commit 36e4f036cfab9e283f6b47bd5e3890a4de54c5ff)
```

### Usage ###
```
$ sudo env "PATH=${PATH}" env "FACTER_gover=<DESIRED_GO_VERSION>" puppet apply /path/to/github/clone/<PACKAGE>/install_<PACKAGE>.pp
```

