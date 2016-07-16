# Creates the dhparam.pem file in /etc/ssl
class sslcert::dhparam (
  $pempath = $sslcert::params::dhparampempath,
) inherits sslcert::params  {
  file { $pempath:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/sslcert/dhparam.pem',
  }
}
