# defines hosts and locations for ganglia.go2tech.de
class role::nginx::ganglia_go2tech {
  droidwiki::nginx::hhvmvhost { 'ganglia.go2tech.de':
    vhost_url => 'ganglia.go2tech.de',
  }
}
