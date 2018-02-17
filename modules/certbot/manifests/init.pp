# Module, which manages the certbot automatic renewel
# of certificates. Unfortunately, currently does not
# handle the the process of getting a new certificate.
class certbot {
  # remove old version of certbot for trusty - 17. Feb 2018
  file { '/usr/local/sbin/certbot-auto':
    ensure => 'absent',
  }

  apt::ppa { 'ppa:certbot/certbot': }

  package { 'certbot':
    ensure  => 'present',
    require => [
      Apt::Ppa['ppa:certbot/certbot'],
      Exec['apt_update'],
    ]
  }

  cron { 'letsencrypt renew cron':
    command => '/usr/bin/certbot renew --quiet --no-self-upgrade --renew-hook "service nginx restart"',
    user    => root,
    hour    => 2,
    minute  => 30,
    weekday => 1,
  }
}
