#
# Author: Viv Diwakar <viv@vdiwakar.com>
# Date:   20170404
#
# Installer for downloading updtream Go, and installing
#

$paths = [
  '/bin',
  '/usr/bin',
  '/usr/local/bin',
]

exec { 'update_go_paths':
  require => Exec[
    'deploy_go_source'
  ],
  cwd => "/home/$::guser",
  path => $paths,
  command => "echo $::guser > gopher.txt",
  creates => "/home/$::guser/gopher.txt",
  returns => [0],
  logoutput => on_failure,
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

