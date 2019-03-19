# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# A fragment of data for a datacat resource.
Puppet::Resource::ResourceType3.new(
  'datacat_fragment',
  [

  ],
  [
    # The name of this fragment.
    Puppet::Resource::Param(Any, 'name', true),

    # The title of the datacat resource that the data should be considered part of.  May be an array to indicate multiple targetted collectors.
    Puppet::Resource::Param(Any, 'target'),

    # The order in which to merge this fragment into the datacat resource.  Defaults to the string "50"
    Puppet::Resource::Param(Any, 'order'),

    # A hash of data to be merged for this resource.
    Puppet::Resource::Param(Any, 'data'),

    # The specific backend to use for this `datacat_fragment`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # datacat_fragment
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
