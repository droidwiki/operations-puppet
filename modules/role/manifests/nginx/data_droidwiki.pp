# data.droidwiki.de class
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::data_droidwiki {
  droidwiki::nginx::mediawiki { 'data.droidwiki.de':
    vhost_url             => 'data.droidwiki.de',
    server_name           => [ 'data.droidwiki.de' ],
    manage_directories    => false,
    manage_http_redirects => true,
    html_root             => '/data/www/droidwiki.de/public_html',
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => '/etc/letsencrypt/live/droidwiki.de/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/droidwiki.de/privkey.pem',
  }
}
