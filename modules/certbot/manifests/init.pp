# Module, which manages the certbot automatic renewel
# of certificates. Unfortunately, currently does not
# handle the the process of getting a new certificate.
class certbot {
  file { '/usr/local/sbin/certbot-auto':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '755',
    source => 'puppet:///modules/certbot/certbot-auto',
  }

  cron { "letsencrypt renew cron":
    command => 'certbot-auto renew --quiet --no-self-upgrade',
    user    => root,
    hour    => 2,
    minute  => 30,
    weekday => 1,
  }
}
