#
# Author: Viv Diwakar <viv@vdiwakar.com>
# Date:   20170406
#
# Installer for downloading upstream Go, and installing
#

include '::archive'
include stdlib

$paths = [ '/bin', '/usr/bin', '/usr/local/bin' ]

# Add the Go binary ${GOBIN} path to ${PATH}
exec { 'update_gobin_path':
  require => File_Line['add_gobin_path'],
  cwd => "/home/$::guser",
  path => $paths,
  command => "sed -e '/\${GOBIN}/! s/\(.* PATH=.*\)/\1:\${GOBIN}/g' -i.bak.`date +%Y%m%d-%s` /home/$::guser/.bashrc",
  returns => [0],
  logoutput => on_failure,
}

# Add the ${GOBIN} path
file_line { 'add_gobin_path':
  require => File_Line['add_gopath_path'],
  path => "/home/$::guser/.bashrc",
  line => "export GOBIN=\${GOPATH}/bin",
}

# Add the ${GOPATH} path
file_line { 'add_gopath_path':
  require => File["/home/$::guser/$::gpath/go/bin"],
  path => "/home/$::guser/.bashrc",
  line => "export GOPATH=\${HOME}/$::gpath/go",
}

# Create the ${GOPATH} environment
file { [ "/home/$::guser/$::gpath", "/home/$::guser/$::gpath/go", "/home/$::guser/$::gpath/go/bin", "/home/$::guser/$::gpath/go/src", "/home/$::guser/$::gpath/go/pkg" ]:
  require => Exec['update_exec_path'],
  ensure => 'directory',
  owner  => "$::guser",
  group  => "$::guser",
  mode   => '0755',
}

# Add the Go binary ${GOROOT}/bin path to ${PATH}
exec { 'update_exec_path':
  require => File_Line['add_goroot_path'],
  cwd => "/home/$::guser",
  path => $paths,
  command => "sed -e '/\${GOROOT}\/bin/! s/\(.* PATH=.*\)/\1:\${GOROOT}\/bin/g' -i.bak.`date +%Y%m%d-%s` /home/$::guser/.bashrc",
  returns => [0],
  logoutput => on_failure,
}

# Add the GOROOT path
file_line { 'add_goroot_path':
  require => Archive["go$::gover.linux-amd64.tar.gz"],
  path => "/home/$::guser/.bashrc",
  line => 'export GOROOT=/usr/local/go',
}

# Download and extract the upstream binary
archive { "go$::gover.linux-amd64.tar.gz":
  require => Exec['check_curr_ver'],
  path          => "/tmp/go$::gover.linux-amd64.tar.gz",
  source        => "https://storage.googleapis.com/golang/go$::gover.linux-amd64.tar.gz",
  extract       => true,
  extract_path  => '/usr/local',
  creates       => '/usr/local/go',
  cleanup       => false,
}

# check existing version of Go, if any
exec { 'check_curr_ver':
  cwd => '/usr/local',
  path => $paths,
  command => 'mv -v /usr/local/go{,.old.`date +%Y%m%d-%s`}',
  onlyif => [
    'test -d /usr/local/go',
    'test -x /usr/local/go/bin/go',
    "test \"`/usr/local/go/bin/go version | awk '{print \$3}'`\" != \"go$::gover\""
  ],
  returns => [0],
  logoutput => on_failure,
}

