#
# Author: Viv Diwakar <viv@vdiwakar.com>
# Date:   20170406
#
# Installer for downloading updtream Go, and installing
#

include '::archive'
include stdlib

$paths = [ '/bin', '/usr/bin', '/usr/local/bin' ]

# Add the GOPATH path
file_line { 'add_gopath_path':
  require => Exec['update_local_path'],
  path => "/home/$::guser/.bashrc",
  line => "export GOPATH=\${HOME}/$::gpath/go",
}

# Add the go workspaces binary path to PATH
exec { 'update_local_path':
  require => File["/home/$::guser/$::gpath/go/bin"],
  cwd => "/home/$::guser",
  path => $paths,
  command => "sed -e '/\/home\/$::guser\/$::gpath\/go\/bin/! s/\(.* PATH=.*\)/\1:\/home\/$::guser\/$::gpath\/go\/bin/g' -i.bak.`date +%Y%m%d-%s` /home/$::guser/.bashrc",
  returns => [0],
  logoutput => on_failure,
}

# Create the environment
file { [ "/home/$::guser/$::gpath", "/home/$::guser/$::gpath/go", "/home/$::guser/$::gpath/go/bin", "/home/$::guser/$::gpath/go/src", "/home/$::guser/$::gpath/go/pkg" ]:
  require => Exec['update_exec_path'],
  ensure => 'directory',
  owner  => "$::guser",
  group  => "$::guser",
  mode   => '0755',
}

# Add the go binary path to PATH
exec { 'update_exec_path':
  require => File_Line['add_goroot_path'],
  cwd => "/home/$::guser",
  path => $paths,
  command => "sed -e '/\/usr\/local\/go\/bin/! s/\(.* PATH=.*\)/\1:\/usr\/local\/go\/bin/g' -i.bak.`date +%Y%m%d-%s` /home/$::guser/.bashrc",
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
  path          => "/tmp/go$::gover.linux-amd64.tar.gz",
  source        => "https://storage.googleapis.com/golang/go$::gover.linux-amd64.tar.gz",
  extract       => true,
  extract_path  => '/usr/local',
  creates       => '/usr/local/go',
  cleanup       => false,
}

