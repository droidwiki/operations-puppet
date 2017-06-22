# This role sets up a gitlab server for the host
class role::gitlab {
  class { 'gitlab': }

  # symlink the authorized_keys file to the git user
  file { '/etc/ssh/userkeys/git':
    ensure => 'link',
    target => '/var/opt/gitlab/.ssh/authorized_keys',
  }
}

