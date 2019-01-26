# Installs and manages bind
class role::dns(
  $type     = 'slave',
  $master_ip = '37.120.178.25',
  $slave_ip  = '188.68.49.74',
) {
  firewall { '700 allow outgoing dns requests':
    sport  => 53,
    proto  => 'udp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '701 allow incoming dns requests':
    dport  => 53,
    proto  => 'udp',
    chain  => 'INPUT',
    action => 'accept',
  }

  firewall { '702 allow outgoing dns requests':
    sport  => 53,
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '703 allow incoming dns requests':
    dport  => 53,
    proto  => 'tcp',
    chain  => 'INPUT',
    action => 'accept',
  }

  file { '/etc/bind/zones':
    ensure => 'directory',
    owner  => 'bind',
    group  => 'bind',
  }

  include bind
  bind::server::conf { '/etc/bind/named.conf':
    directory         => '/etc/bind/zones',
    listen_on_addr    => [ 'any' ],
    listen_on_v6_addr => [ 'any' ],
    allow_query       => [ 'any' ],
    recursion         => 'no',
    allow_transfer    => [ 'none' ],
    zones             => {
      'go2tech.de'    => [
        "type ${type}",
        'file "go2tech.de"',
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droidwiki.org' => [
        "type ${type}",
        'file "droidwiki.org"',
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droid.wiki' => [
        "type ${type}",
        'file "droid.wiki"',
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droid-wiki.org' => [
        "type ${type}",
        'file "droid-wiki.org"',
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
    },
  }

  if $type == 'master' {
    bind::server::file { [ 'go2tech.de', 'droidwiki.org', 'droid.wiki', 'droid-wiki.org' ]:
      zonedir     => '/etc/bind/zones',
      source_base => 'puppet:///modules/role/dns/',
    }
  }
}
