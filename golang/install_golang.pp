#
# Author: 	Viv Diwakar <viv@vdiwakar.com>
# Date:   	20170406
# Last update:	20170503 12:55:44 BST (+0100)
#
# Installer for downloading upstream Go, and installing
#

include '::archive'
include stdlib

$paths = [ '/bin', '/usr/bin', '/usr/local/bin' ]

# Move PATH line to the very last, to ensure Go environment variables are set ahead
exec { 'move_path_line':
  require => Exec['update_gobin_path'],
  cwd => "/home/$::guser",
  path => $paths,
  command => "cp /home/$::guser/.bashrc /tmp/_bashrc && PATH_LINE=`cat /tmp/_bashrc | grep export\ PATH=` && cat /tmp/_bashrc | grep -v export\ PATH= > /tmp/_bashrc.new && echo \"\n\${PATH_LINE}\" >> /tmp/_bashrc.new && cp /tmp/_bashrc.new /home/$::guser/.bashrc",
  returns => [0],
  logoutput => on_failure,
}

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
  command => "mv -v /usr/local/go /usr/local/go`/usr/local/go/bin/go version | awk '{print \$3}' | sed -e 's/go//g'`",
  onlyif => [
    'test -d /usr/local/go',
    'test -x /usr/local/go/bin/go',
    "test \"`/usr/local/go/bin/go version | awk '{print \$3}'`\" != \"go$::gover\""
  ],
  returns => [0],
  logoutput => on_failure,
}

