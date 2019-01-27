# Module, which manages the certbot automatic renewel
# of certificates. Unfortunately, currently does not
# handle the the process of getting a new certificate.
class certbot(
  $mode = 'webroot',
  $hook = 'service nginx restart',
) {
  apt::ppa { 'ppa:certbot/certbot': }

  package { 'certbot':
    ensure  => 'present',
    require => [
      Apt::Ppa['ppa:certbot/certbot'],
      Exec['apt_update'],
    ]
  }

  package { 'python3-certbot-dns-rfc2136':
    ensure  => 'present',
    require => [
      Apt::Ppa['ppa:certbot/certbot'],
      Exec['apt_update'],
    ]
  }

  if ($mode == 'standalone') {
    firewall { '304 accept incoming http traffic':
      proto  => 'tcp',
      dport  => '80',
      action => 'accept',
    }
  }

  cron { 'letsencrypt renew cron':
    command => "/usr/bin/certbot renew --quiet --no-self-upgrade --renew-hook \"${hook}\"",
    user    => root,
    hour    => 2,
    minute  => 30,
    weekday => 1,
  }
}
