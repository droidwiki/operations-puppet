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
    ensure => 'absent',
    force  => true,
    recurse => true,
  }

  file { '/var/lib/bind/zones':
    ensure => 'directory',
    owner  => 'bind',
    group  => 'bind',
  }

  include bind
  bind::server::conf { '/etc/bind/named.conf':
    directory         => '/var/lib/bind/zones',
    listen_on_addr    => [ 'any' ],
    listen_on_v6_addr => [ 'any' ],
    allow_query       => [ 'any' ],
    recursion         => 'no',
    allow_transfer    => [ 'none' ],
    keys              => {
      'letsencrypt.' => [
        'algorithm hmac-sha512',
        "secret \"${hiera('bind::key::letsencrypt')}\"",
      ],
    },
    zones             => {
      'go2tech.de'     => [
        "type ${type}",
        'file "go2tech.de"',
        $type ? { 'master' => 'update-policy { grant letsencrypt. name _acme-challenge.go2tech.de. txt; }', default => '// omitting update-policy on slave' },
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droidwiki.org'  => [
        "type ${type}",
        'file "droidwiki.org"',
        $type ? { 'master' => 'update-policy { grant letsencrypt. name _acme-challenge.droidwiki.org. txt; }', default => '// omitting update-policy on slave' },
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droid.wiki'     => [
        "type ${type}",
        'file "droid.wiki"',
        $type ? { 'master' => 'update-policy { grant letsencrypt. name _acme-challenge.droid.wiki. txt; }', default => '// omitting update-policy on slave' },
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
      'droid-wiki.org' => [
        "type ${type}",
        'file "droid-wiki.org"',
        $type ? { 'master' => 'update-policy { grant letsencrypt. name _acme-challenge.droid-wiki.org. txt; }', default => '// omitting update-policy on slave' },
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
    },
  }

  if $type == 'master' {
    bind::server::file { [ 'go2tech.de', 'droidwiki.org', 'droid.wiki', 'droid-wiki.org' ]:
      zonedir     => '/var/lib/bind/zones',
      source_base => 'puppet:///modules/role/dns/',
    }

    file { '/etc/bind/rfc2136_letsencrypt.ini':
      content => template('role/dns/rfc2136_letsencrypt.ini.erb'),
      mode    => '0600',
    }
  }
}
