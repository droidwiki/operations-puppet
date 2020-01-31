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

  firewall { '700 allow outgoing dns requests IPv6':
    sport    => 53,
    proto    => 'udp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '701 allow incoming dns requests':
    dport  => 53,
    proto  => 'udp',
    chain  => 'INPUT',
    action => 'accept',
  }

  firewall { '701 allow incoming dns requests IPv6':
    dport    => 53,
    proto    => 'udp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '702 allow outgoing dns requests':
    sport  => 53,
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '702 allow outgoing dns requests IPv6':
    sport    => 53,
    proto    => 'tcp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '703 allow incoming dns requests':
    dport  => 53,
    proto  => 'tcp',
    chain  => 'INPUT',
    action => 'accept',
  }

  firewall { '703 allow incoming dns requests IPv6':
    dport    => 53,
    proto    => 'tcp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  file { '/var/lib/bind/zones':
    ensure => 'directory',
    owner  => 'bind',
    group  => 'bind',
  }

  monit::service { 'bind9': }

  include bind
  bind::server::conf { '/etc/bind/named.conf':
    acls                => {
      'internal' => [ '172.16.0.0/16' ],
    },
    directory           => '/var/lib/bind/zones',
    listen_on_addr      => [ 'any' ],
    listen_on_v6_addr   => [ 'any' ],
    allow_query         => [ 'any' ],
    recursion           => 'no',
    allow_transfer      => [ 'none' ],
    keys                => {
      'letsencrypt.' => [
        'algorithm hmac-sha512',
        "secret \"${hiera('bind::key::letsencrypt')}\"",
      ],
    },
    zones               => {
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
      'floriansw.de'   => [
        "type ${type}",
        'file "floriansw.de"',
        $type ? { 'master' => 'update-policy { grant letsencrypt. name _acme-challenge.floriansw.de. txt; }', default => '// omitting update-policy on slave' },
        $type ? { 'slave' => "masters { ${master_ip}; }", default => "allow-transfer { ${slave_ip}; }" }
      ],
    },
  }

  if $type == 'master' {
    exec { 'rndc freeze':
      command => '/usr/sbin/rndc freeze',
      user    => root,
      group   => root,
    }

    exec { 'rndc thaw':
      command => '/usr/sbin/rndc thaw',
      user    => root,
      group   => root,
      require => File['/var/lib/bind/zones/go2tech.de', '/var/lib/bind/zones/droidwiki.org', '/var/lib/bind/zones/droid.wiki', '/var/lib/bind/zones/droid-wiki.org', '/var/lib/bind/zones/floriansw.de'],
    }

    bind::server::file { [ 'go2tech.de', 'droidwiki.org', 'droid.wiki', 'droid-wiki.org', 'floriansw.de' ]:
      zonedir     => '/var/lib/bind/zones',
      source_base => 'puppet:///modules/role/dns/',
    }

    file { '/etc/bind/rfc2136_letsencrypt.ini':
      content => template('role/dns/rfc2136_letsencrypt.ini.erb'),
      mode    => '0600',
    }
  }
}
