# Role for DroidWiki datawiki
class role::datawiki {
  # Starts a dispatcher instance every 3 minutes
  # They will run for a maximum of 9 minutes, so we can only have 3 concurrent instances.
  # This handles inserting jobs into client job queue, which then process the changes
  cron { 'datawiki-dispatch-changes':
    ensure  => present,
    command => 'docker run -it --rm --net=host -u $(id -u www-data) -v /data:/data -w /data/mediawiki droidwiki/php-fpm:7.4 php /data/mediawiki/mw-config/mw-config/multiversion/MWScript.php extensions/Wikibase/repo/maintenance/dispatchChanges.php --wiki datawiki --max-time 540 --batch-size 275 --dispatch-interval 25 >/dev/null 2>&1',
    user    => 'root',
    minute  => '*/3',
  }

  # Prune wb_changes entries no longer needed from (test)wikidata
  cron { 'datawiki-prune':
    ensure  => present,
    command => 'docker run -it --rm --net=host -u $(id -u www-data) -v /data:/data -w /data/mediawiki droidwiki/php-fpm:7.4 php /data/mediawiki/mw-config/mw-config/multiversion/MWScript.php extensions/Wikibase/repo/maintenance/pruneChanges.php --wiki datawiki --number-of-days=3 >> /data/log/mediawiki/prune.log 2>&1',
    user    => 'root',
    minute  => [0,15,30,45],
  }
}

