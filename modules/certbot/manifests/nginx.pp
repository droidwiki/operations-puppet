# Handles restarts of docker based nginx when certificates
# are renewed
class certbot::nginx {
  cron { 'letencrypt reload nginx on new certs':
    command => "find /data/ha_volume/nginx/certs/droidwiki.org/ -mtime -1 | egrep '.*' > /dev/null && docker service update webserver_frontend-proxy --force",
    user    => root,
    hour    => 3,
    minute  => 0,
    weekday => 1,
  }
}
