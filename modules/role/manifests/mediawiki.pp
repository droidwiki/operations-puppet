# This role ensures, that the mediawiki
# directory in the /data partition is
# present and setup correctly.
class role::mediawiki{
  file{ '/data/mediawiki':
    ensure => 'directory',
    mode   => '0775',
    owner  => 'florian',
    group  => 'florian',
  }

  file{ $droidwiki::params::mediawiki_wwwroot:
    ensure => 'directory',
    mode   => '0775',
    owner  => 'florian',
    group  => 'florian',
  }
}
