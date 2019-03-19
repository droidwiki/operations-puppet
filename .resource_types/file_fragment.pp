# This file was automatically generated on 2019-03-19 19:06:35 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# Create a file fragment to be used by file_concat.
# the `file_fragment` type creates a file fragment to be collected by file_concat based on the tag.
# The example is based on exported resources.
# 
# Example:
# @@file_fragment { "uniqe_name_${::fqdn}":
#   tag => 'unique_name',
#   order => 10, # Optional. Default to 10
#   content => 'some content' # OR
#   content => template('template.erb') # OR
#   source  => 'puppet:///path/to/file'
# }
Puppet::Resource::ResourceType3.new(
  'file_fragment',
  [

  ],
  [
    # Unique name
    Puppet::Resource::Param(Any, 'name', true),

    # Content
    Puppet::Resource::Param(Any, 'content'),

    # Source
    Puppet::Resource::Param(Any, 'source'),

    # Order
    Puppet::Resource::Param(Any, 'order'),

    # Tag name to be used by file_concat to collect all file_fragments by tag name
    Puppet::Resource::Param(Any, 'tag')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
