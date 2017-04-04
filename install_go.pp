#
# Author: Viv Diwakar <viv@vdiwakar.com>
# Date:   20170404
#

$go_version = '1.8'
$paths = [
  '/bin',
  '/usr/bin',
  '/usr/local/bin',
]

file { '/tmp/go':
  require => Exec["deploy_go_source"],
}

exec { "retrieve_go_source":
  cwd => '/tmp',
  path => $paths,
  command => "wget -v https://storage.googleapis.com/golang/go$go_version.linux-amd64.tar.gz",
  creates => "/tmp/go$go_version.linux-amd64.tar.gz",
  returns => [0],
  logoutput => on_failure,
}

exec { "deploy_go_source":
  cwd => '/tmp',
  path => $paths,
  command => "tar -zxf go$go_version.linux-amd64.tar.gz -C /tmp",
  creates => "/tmp/go",
  returns => [0],
  logoutput => on_failure,
  require => Exec["retrieve_go_source"],
}

