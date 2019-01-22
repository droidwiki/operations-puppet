# Installs and configures filebeat
class role::filebeat(
  $manage_repo = true,
) {
  class { 'filebeat':
    package_ensure => '5.5.1',
    major_version  => '5',
    manage_repo    => $manage_repo,
    outputs        => {
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
