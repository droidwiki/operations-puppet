# site.pp
node 'eclair.dwnet' {
  include droidwiki::default
  include role::webserver
}

node default {
  include droidwiki::default
  include role::webserver
  class { 'certbot':
    hook => 'cp -R -L /etc/letsencrypt/live/droidwiki.org/ /data/ha_volume/nginx/nginx/certs/',
  }
  include certbot::nginx
  include role::dns
}
