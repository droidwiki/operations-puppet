# vhost and locations for dev.go2tech.de
class role::nginx::dev_go2tech {
  droidwiki::nginx::mediawiki { 'dev.go2tech.de':
    vhost_url         => 'dev.go2tech.de',
    server_name       => [ 'dev.go2tech.de' ],
    mediawiki_wwwroot => '/data/www/dev.go2tech.de/public_html/',
  }
}