# defines hosts and locations for puppetboard.go2tech.de
class role::nginx::puppetboard_go2tech {
  droidwiki::nginx::uwsgivhost { 'puppetboard.go2tech.de':
    vhost_url  => 'puppetboard.go2tech.de',
    uwsgi_port => '3032',
    auth_basic => 'Puppetboard',
    auth_basic_user_file => '/data/www/puppetboard.go2tech.de/access.htpasswd',
  }
}
