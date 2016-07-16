# defines hosts and locations for graphite.go2tech.de
class role::nginx::graphite_go2tech {
  droidwiki::nginx::uwsgivhost { 'graphite.go2tech.de':
    vhost_url => 'graphite.go2tech.de',
  }
}
