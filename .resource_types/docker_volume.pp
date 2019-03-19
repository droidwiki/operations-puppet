# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# A type representing a Docker volume
Puppet::Resource::ResourceType3.new(
  'docker_volume',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The volume driver used by the volume
    Puppet::Resource::Param(Any, 'driver'),

    # Additional options for the volume driver
    Puppet::Resource::Param(Any, 'options'),

    # The location that the volume is mounted to
    Puppet::Resource::Param(Any, 'mountpoint')
  ],
  [
    # The name of the volume
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `docker_volume`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Support for Docker Volumes
    # 
    #   * Required binaries: `docker`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
