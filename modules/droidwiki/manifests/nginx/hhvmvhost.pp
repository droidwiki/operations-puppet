# a template for a simple hhvm configuration of nginx
define droidwiki::nginx::hhvmvhost (
  $ensure               = 'present',
  $vhost_url            = undef,
  $custom_server_name   = undef,
  $auth_basic           = undef,
  $auth_basic_user_file = undef,
  $www_root             = undef,
  $ipv6_enable          = true,
) {
  validate_string($vhost_url)
  validate_bool($ipv6_enable)

  if ( $custom_server_name != undef ) {
    validate_array($custom_server_name)
    $server_name = $custom_server_name
  } else {
    $server_name = [ $vhost_url ]
  }

  if ( $ensure != 'present' ) {
    $file_ensure = $ensure
  } else {
    $file_ensure = 'directory'
  }

  if ( $www_root == undef ) {
    file { "/data/www/${vhost_url}":
      ensure => $file_ensure,
      force  => true,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }

    file { "/data/www/${vhost_url}/public_html":
      ensure => $file_ensure,
      force  => true,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }

    $root = "/data/www/${vhost_url}/public_html"
  } else {
    $root = $www_root
  }

  nginx::resource::vhost { $vhost_url:
    ensure               => $ensure,
    use_default_location => false,
    ipv6_enable          => $ipv6_enable,
    ipv6_listen_options  => '',
    server_name          => $server_name,
    www_root             => $root,
  }

  nginx::resource::location { "${vhost_url}/ .php":
    ensure               => $ensure,
    vhost                => $vhost_url,
    auth_basic           => $auth_basic,
    auth_basic_user_file => $auth_basic_user_file,
    location             => '~ \.php',
    fastcgi              => '127.0.0.1:9000',
  }
}
