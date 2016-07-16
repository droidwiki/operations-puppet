# a template for a simple uwsgi configuration of nginx
define droidwiki::nginx::uwsgivhost (
  $vhost_url            = undef,
  $custom_server_name   = undef,
  $auth_basic           = undef,
  $auth_basic_user_file = undef,
  $uwsgi_port           = '9000',
) {
  validate_string($vhost_url);

  if ( $custom_server_name != undef ) {
    validate_array($custom_server_name)
    $server_name = $custom_server_name
  } else {
    $server_name = [ $vhost_url ]
  }
  file { "/data/www/${vhost_url}":
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { "/data/www/${vhost_url}/public_html":
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { $vhost_url:
    use_default_location => false,
    server_name          => $server_name,
  }

  nginx::resource::location { "${vhost_url}/ .php":
    vhost                => $vhost_url,
    auth_basic           => $auth_basic,
    auth_basic_user_file => $auth_basic_user_file,
    location             => '/',
    uwsgi                => "127.0.0.1:${uwsgi_port}",
  }
}
