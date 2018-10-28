# Puppet class, which provides a droidwiki wiki
# ALWAYS PAIR WITH CERTBOT!
define role::nginx::wiki(
  $domain      = Undef,
  $server_name = Undef
) {
  validate_string($domain)
  if ($server_name == Undef) {
    $server_name = [ $domain ]
  }

  droidwiki::nginx::mediawiki { $domain:
    vhost_url             => $domain,
    server_name           => [ $domain ],
    manage_directories    => false,
    manage_http_redirects => true,
    html_root             => '/data/www/droidwiki.de/public_html',
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => hiera('nginx::tls::fullchain'),
    ssl_key               => hiera('nginx::tls::privkey'),
  }

  monit::certcheck { $domain: }
}
