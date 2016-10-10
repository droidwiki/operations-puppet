define monit::service() {
  file { "/etc/monit/conf.d/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("monit/${name}.erb"),
    notify  => Service['monit'],
    require => [
      File['conf.d'],
      Package['monit']
    ],
  }
}
