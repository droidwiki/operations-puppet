# Manages logstash
class role::logstash(
  $redis_input_host          = '127.0.0.1',
  $redis_input_port          = 6379,
  $redis_input_data_type     = 'list',
  $redis_input_key           = 'logstash',
  $rsyslog_input_port        = 1514,
  $gelf_input_port           = 12201,
  $es_output_flush_size      = 5000,
  $es_output_host            = '188.68.49.74',
  $es_output_port            = 9200,
  $es_output_idle_flush_time = 1,
) {
  class { 'logstash':
    version     => '1:5.5.1-1',
  }

  # needed for filter-mediawiki
  logstash::plugin { 'logstash-filter-anonymize': }
  logstash::plugin { 'logstash-filter-multiline': }

  # accept logs from filebeat
  logstash::plugin { 'logstash-input-beats': }

  logstash::configfile { 'input-redis-log':
    content => template('role/logstash/redis_input.erb'),
  }

  logstash::configfile { 'input-rsyslog-log':
    content => template('role/logstash/rsyslog_input.erb'),
  }

  # implemented for citoid
  logstash::configfile { 'input-gelf-log':
    content => template('role/logstash/gelf_input.erb'),
  }

  logstash::configfile { 'input-nginx-log':
    content => template('role/logstash/nginx_input.erb'),
  }

  logstash::configfile { 'input-beats':
    content => template('role/logstash/beats_input.erb'),
  }

  $es_output_index = 'logstash-%{+YYYY.MM.dd}'

  logstash::configfile { 'output-es-log':
    content => template('role/logstash/es_output.erb'),
  }

  logstash::configfile { 'filter-mediawiki':
    source => 'puppet:///modules/role/logstash/filter-mediawiki.conf',
  }

  logstash::configfile { 'filter_syslog':
    source => 'puppet:///modules/role/logstash/filter-syslog.conf',
  }

  logstash::configfile { 'filter_gelf':
    source => 'puppet:///modules/role/logstash/filter-gelf.conf',
  }

  logstash::configfile { 'filter-nginx':
    source => 'puppet:///modules/role/logstash/filter-nginx.conf',
  }

  file { '/usr/local/bin/logstash_delete_index.sh':
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
    source => 'puppet:///modules/role/logstash/scripts/logstash_delete_index.sh',
  }

  cron { 'logstash_delete_index':
    ensure  => 'present',
    command => "/usr/local/bin/logstash_delete_index.sh ${es_output_host}:${es_output_port} \"logstash-$(date -d '-31days' +\\%Y.\\%m.\\%d)\"",
    user    => 'root',
    hour    => 0,
    minute  => 42,
    require => File['/usr/local/bin/logstash_delete_index.sh'],
  }
}
