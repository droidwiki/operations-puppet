# vhost and locations for ops.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::ops_go2tech {
  $sslcert = '/etc/letsencrypt/live/blog.go2tech.de/fullchain.pem';
  $sslkey = '/etc/letsencrypt/live/blog.go2tech.de/privkey.pem';

  droidwiki::nginx::mediawiki { 'ops.go2tech.de':
    vhost_url             => 'ops.go2tech.de',
    server_name           => [ 'ops.go2tech.de' ],
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => $sslcert,
    ssl_key               => $sslkey,
    manage_http_redirects => true,
  }

  monit::certcheck { 'ops.go2tech.de': }
}
