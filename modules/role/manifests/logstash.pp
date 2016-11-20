# Manages logstash
# This class will install redis, which needs to be used as the
# log target. This should, however, be changed in the future, so
# that redis will be installed standalone outside this module.
class role::logstash(
  $redis_input_host          = '127.0.0.1',
  $redis_input_port          = 6379,
  $redis_input_data_type     = 'list',
  $redis_input_key           = 'logstash',
  $es_output_flush_size      = 5000,
  $es_output_host            = '127.0.0.1',
  $es_output_port            = 9200,
  $es_output_idle_flush_time = 1,
) {
  class { 'redis':
    bind => '0.0.0.0';
  }

  class { 'logstash':
    manage_repo  => true,
  }

  logstash::configfile { 'input-redis-log':
    content  => template('role/logstash/redis_input.erb'),
  }

  $es_output_index = 'logstash-%{+YYYY.MM.dd}'

  logstash::configfile { 'output-es-log':
    content  => template('role/logstash/es_output.erb'),
  }
}
