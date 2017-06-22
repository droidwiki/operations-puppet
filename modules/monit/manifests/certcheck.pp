# Creates a monitored service file for a pre-defined template
define monit::certcheck(
    $host               = $name,
    $port               = '443',
    $protocol           = 'https',
    $cert_valid_greater = '15',
) {
  file { "/etc/monit/conf.d/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monit/certcheck.erb'),
    notify  => Service['monit'],
    require => [
      File['conf.d'],
      Package['monit']
    ],
  }
}
