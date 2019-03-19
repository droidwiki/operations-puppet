# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# A type representing a Docker Compose file
Puppet::Resource::ResourceType3.new(
  'docker_compose',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # A hash of compose services and number of containers.
    Puppet::Resource::Param(Any, 'scale'),

    # Additional options to be passed directly to docker-compose.
    Puppet::Resource::Param(Any, 'options'),

    # Arguments to be passed directly to docker-compose up.
    Puppet::Resource::Param(Any, 'up_args'),

    # An array of Docker Compose Files paths.
    Puppet::Resource::Param(Any, 'compose_files'),

    # The name of the project
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `docker_compose`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Support for Puppet running Docker Compose
    # 
    #   * Required binaries: `docker-compose`, `docker`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
