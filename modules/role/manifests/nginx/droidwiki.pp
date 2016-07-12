# nginx vhost droidwiki.de
class role::nginx::droidwiki {
  include role::nginx::ssl
  nginx::site{ 'droidwiki.de':
    content => template('droidwiki/droidwiki.conf.erb')
  }
}
