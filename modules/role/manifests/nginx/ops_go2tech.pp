# vhost and locations for ops.go2tech.de
class role::nginx::ops_go2tech {
  droidwiki::nginx::mediawiki { 'ops.go2tech.de':
    vhost_url             => 'ops.go2tech.de',
    server_name           => [ 'ops.go2tech.de' ],
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => '/etc/letsencrypt/live/blog.go2tech.de/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/blog.go2tech.de/privkey.pem',
    manage_http_redirects => true,
  }
}
