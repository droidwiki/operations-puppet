# vhost and locations for ops.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::ops_go2tech {
  droidwiki::nginx::mediawiki { 'ops.go2tech.de':
    vhost_url             => 'ops.go2tech.de',
    server_name           => [ 'ops.go2tech.de' ],
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => hiera('nginx::tls::fullchain'),
    ssl_key               => hiera('nginx::tls::privkey'),
    manage_http_redirects => true,
  }

  monit::certcheck { 'ops.go2tech.de': }
}
