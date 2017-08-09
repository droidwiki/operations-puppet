# Installs and configures filebeat
class role::filebeat {
  class { 'filebeat':
    outputs => {
      'logstash' => {
      'hosts'    => [
          'eclair.dwnet:5044'
        ],
      },
    },
  }

  filebeat::prospector { 'nginx_access_logs':
    paths         => [
      '/var/log/nginx/*access*',
    ],
    doc_type      => 'nginx',
    tags          => [
      'nginx',
      'nginx-access',
    ],
    exclude_files => [
      '\.gz$'
    ],
  }

  filebeat::prospector { 'nginx_error_logs':
    paths         => [
      '/var/log/nginx/*error*',
    ],
    doc_type      => 'nginx',
    tags          => [
      'nginx',
      'nginx-error',
    ],
    exclude_files => [
      '\.gz$'
    ],
  }
}
