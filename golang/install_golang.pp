#
# Author: Viv Diwakar <viv@vdiwakar.com>
# Date:   20170404
#
# Installer for downloading updtream Go, and installing
#

include stdlib

$paths = [
  '/bin',
  '/usr/bin',
  '/usr/local/bin',
]

exec { 'update_exec_path':
  require => File_Line[
    'add_goroot_path'
  ],
  cwd => "/home/$::guser",
  path => $paths,
  command => "sed -e 's/\(.* PATH=.*\)/\1:\/usr\/local\/go\/bin/g' -i.bak.`date +%Y%m%d-%s` /home/$::guser/.bashrc",
  returns => [0],
  logoutput => on_failure,
}

file_line { 'add_goroot_path':
  require => Exec[
    'deploy_go_source'
  ],
  path => "/home/$::guser/.bashrc",
  line => 'export GOROOT=/usr/local/go',
}

exec { 'deploy_go_source':
  require => Exec[
    'retrieve_go_source'
  ],
  cwd => '/tmp',
  path => $paths,
  command => "tar -zxf go$::gover.linux-amd64.tar.gz -C /usr/local",
  creates => '/usr/local/go',
  returns => [0],
  logoutput => on_failure,
}

exec { 'retrieve_go_source':
  cwd => '/tmp',
  path => $paths,
  command => "wget -v https://storage.googleapis.com/golang/go$::gover.linux-amd64.tar.gz",
  creates => "/tmp/go$::gover.linux-amd64.tar.gz",
  returns => [0],
  logoutput => on_failure,
}

