# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# Manages the merging of data and updating a related resource parameter.
# 
# The `datacat_collector` type deeply merges a data hash from
# the `datacat_fragment` resources that target it.
# 
# These fragments are then rendered via an erb template specified by the
# `template_body` parameter and used to update the `target_field` property
# of the related `target_resource`.
# 
# Sample usage:
# 
#   datacat_collector { 'open_ports':
#     template_body => '<%= @data["ports"].sort.join(",") %>',
#     target_resource => File_line['open_ports'],
#     target_field    => 'line',
#   }
# 
#   datacat_fragment { 'open webserver':
#     target => 'open_ports',
#     data   => { ports => [ 80, 443 ] },
#   }
# 
#   datacat_fragment { 'open ssh':
#     target => 'open_ports',
#     data   => { ports => [ 22 ] },
#   }
# 
# 
# For convenience the common use case of targeting a file is wrapped in the
# datacat defined type.
Puppet::Resource::ResourceType3.new(
  'datacat_collector',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An identifier (typically a file path) that can be used by datacat_fragments so they know where to target the data.
    Puppet::Resource::Param(Any, 'path', true),

    # Other resources we want to collect data from.  Allows for many-many datacats.
    Puppet::Resource::Param(Any, 'collects'),

    # The resource that we're going to set the field (eg File['/tmp/demo']) set theto set data tor
    Puppet::Resource::Param(Any, 'target_resource'),

    # The field of the resource to put the results in
    Puppet::Resource::Param(Any, 'target_field'),

    # If specified, the key from @data to copy across to the target_field (bypasses template evaluation)
    Puppet::Resource::Param(Any, 'source_key'),

    # Path to the template to render.  Used in error reporting.
    Puppet::Resource::Param(Any, 'template'),

    # The slurped body of the template to render.
    Puppet::Resource::Param(Any, 'template_body'),

    # The specific backend to use for this `datacat_collector`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # datacat_collector
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['path']
  },
  true,
  false)
