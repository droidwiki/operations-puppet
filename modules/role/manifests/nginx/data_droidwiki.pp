# data.droidwiki.de class
class role::nginx::data_droidwiki {
  droidwiki::nginx::mediawiki { 'data.droidwiki.de':
    vhost_url             => 'data.droidwiki.de',
    server_name           => [ 'data.droidwiki.de' ],
    manage_directories    => false,
    manage_http_redirects => true,
    html_root             => '/data/www/droidwiki.de/public_html',
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => '/data/www/droidwiki.de/droidwiki.de.2017.crt',
    ssl_key               => '/data/www/droidwiki.de/droidwiki.de.decrypted.key',
  }
}
