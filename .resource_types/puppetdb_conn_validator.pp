# This file was automatically generated on 2019-03-19 19:06:36 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# Verify that a connection can be successfully established between a node
# and the puppetdb server.  Its primary use is as a precondition to
# prevent configuration changes from being applied if the puppetdb
# server cannot be reached, but it could potentially be used for other
# purposes such as monitoring.
Puppet::Resource::ResourceType3.new(
  'puppetdb_conn_validator',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The DNS name or IP address of the server where puppetdb should be running.
    Puppet::Resource::Param(Any, 'puppetdb_server'),

    # The port that the puppetdb server should be listening on.
    Puppet::Resource::Param(Any, 'puppetdb_port'),

    # Whether the connection will be attemped using https
    Puppet::Resource::Param(Any, 'use_ssl'),

    # URL to use for testing if the PuppetDB database is up
    Puppet::Resource::Param(Any, 'test_url'),

    # The max number of seconds that the validator should wait before giving up and deciding that puppetdb is not running; defaults to 15 seconds.
    Puppet::Resource::Param(Any, 'timeout'),

    # The specific backend to use for this `puppetdb_conn_validator`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # puppet_https
    # : A provider for the resource type `puppetdb_conn_validator`,
    #   which validates the puppetdb connection by attempting an http(s)
    #   connection to the puppetdb server.  Uses the puppet SSL certificate
    #   setup from the local puppet environment to authenticate if use_ssl
    #   is set to true.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
