# defines hosts and locations for git.go2tech.de
class role::nginx::git_go2tech {
  droidwiki::nginx::hhvmvhost { 'git.go2tech.de':
    vhost_url => 'git.go2tech.de',
  }
}
