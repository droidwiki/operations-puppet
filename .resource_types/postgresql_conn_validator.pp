# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# Verify that a connection can be successfully established between a node
# and the PostgreSQL server.  Its primary use is as a precondition to
# prevent configuration changes from being applied if the PostgreSQL
# server cannot be reached, but it could potentially be used for other
# purposes such as monitoring.
Puppet::Resource::ResourceType3.new(
  'postgresql_conn_validator',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The name of the database you are trying to validate a connection with.
    Puppet::Resource::Param(Any, 'db_name'),

    # A user that has access to the target PostgreSQL database.
    Puppet::Resource::Param(Any, 'db_username'),

    # The password required to access the target PostgreSQL database.
    Puppet::Resource::Param(Any, 'db_password'),

    # The DNS name or IP address of the server where PostgreSQL should be running.
    Puppet::Resource::Param(Any, 'host'),

    # The port that the PostgreSQL server should be listening on.
    Puppet::Resource::Param(Any, 'port'),

    # Hash of environment variables for connection to a db.
    Puppet::Resource::Param(Any, 'connect_settings'),

    # The length of sleep time between connection tries.
    Puppet::Resource::Param(Any, 'sleep'),

    # The number of tries to validate the connection to the target PostgreSQL database.
    Puppet::Resource::Param(Any, 'tries'),

    # Path to the psql command.
    Puppet::Resource::Param(Any, 'psql_path'),

    # System user that will run the psql command.
    Puppet::Resource::Param(Any, 'run_as'),

    # Command to run against target database.
    Puppet::Resource::Param(Any, 'command'),

    # The specific backend to use for this `postgresql_conn_validator`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : A provider for the resource type `postgresql_conn_validator`,
    #   which validates the PostgreSQL connection by attempting a query
    #   to the target PostgreSQL server.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
