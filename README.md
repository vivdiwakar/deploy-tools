# deploy-tools
Deployment scripts to install languages locally using Puppet (on an Ubuntu-based host).

### Install Puppet agent to manage installs from manifests ###
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
$ sed -e '/\/opt\/puppetlabs\/bin/! s/\(.* PATH=.*\)/\1:\/opt\/puppetlabs\/bin/g' -i.bak.`date +%Y%m%d-%s` ${target}
$ . ${target}
$ puppet help | grep \^Puppet 
Puppet v4.9.4
$ facter -v
3.6.2 (commit 36e4f036cfab9e283f6b47bd5e3890a4de54c5ff)
```

### Install additional Puppet libraries ###
```
$ sudo env "PATH=${PATH}" puppet module install puppetlabs-stdlib
$ sudo env "PATH=${PATH}" puppet module install puppet-archive
$ sudo env "PATH=${PATH}" puppet module install puppetlabs-docker_platform
$ sudo env "PATH=${PATH}" puppet module list | grep -E archive\|stdlib\|docker 
├── garethr-docker (v5.3.0)
├── puppet-archive (v1.3.0)
├── puppetlabs-docker_platform (v2.2.1)
├── puppetlabs-stdlib (v4.16.0)
```

### Use installer and verify ###
```
$ sudo env "PATH=${PATH}" env "FACTER_gover=<DESIRED_GO_VERSION>" env "FACTER_guser=<USER>" env "FACTER_gpath=<WORKSPACE_PATH>" puppet apply /path/to/github/clone/<PACKAGE>/install_<PACKAGE>.pp
$ . ~/.bashrc
$ go version 
go version go1.8 linux/amd64
$ set | grep \^GO
GOPATH=/home/vivd/Devel/go
GOROOT=/usr/local/go
```

### Install additional Go tools ###
```
$ go get -v -u github.com/golang/lint/golint
```

---

###### Last Updated: 20170522 13:37:29 BST (+0100) ######

