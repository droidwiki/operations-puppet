# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# A type representing a Docker Stack
Puppet::Resource::ResourceType3.new(
  'docker_stack',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # Path to a Distributed Application Bundle file.
    Puppet::Resource::Param(Any, 'bundle_file'),

    # An array of Docker Compose Files paths.
    Puppet::Resource::Param(Any, 'compose_files'),

    # Arguments to be passed directly to docker stack deploy.
    Puppet::Resource::Param(Any, 'up_args'),

    # The name of the stack
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `docker_stack`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Support for Puppet running Docker Stacks
    # 
    #   * Required binaries: `docker`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
