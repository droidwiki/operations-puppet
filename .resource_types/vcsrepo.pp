# This file was automatically generated on 2020-02-04 21:36:20 +0100.
# Use the 'puppet generate types' command to regenerate this file.

# A local version control repository
Puppet::Resource::ResourceType3.new(
  'vcsrepo',
  [
    # Ensure the version control repository.
    # 
    # Valid values are `present`, `bare`, `mirror`, `absent`, `latest`.
    Puppet::Resource::Param(Enum['present', 'bare', 'mirror', 'absent', 'latest'], 'ensure'),

    # The source URI for the repository
    Puppet::Resource::Param(Any, 'source'),

    # The revision of the repository
    # 
    # Values can match `/^\S+$/`.
    Puppet::Resource::Param(Pattern[/^\S+$/], 'revision'),

    # Paths to be included from the repository
    # 
    # 
    # 
    # Requires features include_paths.
    Puppet::Resource::Param(Any, 'includes'),

    # The repository module to manage
    # 
    # 
    # 
    # Requires features modules.
    Puppet::Resource::Param(Any, 'module')
  ],
  [
    # Absolute path to repository
    Puppet::Resource::Param(Any, 'path', true),

    # Filesystem type
    # 
    # 
    # 
    # Requires features filesystem_types.
    Puppet::Resource::Param(Any, 'fstype'),

    # The user/uid that owns the repository files
    Puppet::Resource::Param(Any, 'owner'),

    # The group/gid that owns the repository files
    Puppet::Resource::Param(Any, 'group'),

    # The user to run for repository operations
    Puppet::Resource::Param(Any, 'user'),

    # Local paths which shouldn't be tracked by the repository
    Puppet::Resource::Param(Any, 'excludes'),

    # Force repository creation, destroying any files on the path in the process.
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'force'),

    # Compression level
    # 
    # 
    # 
    # Requires features gzip_compression.
    Puppet::Resource::Param(Any, 'compression'),

    # HTTP Basic Auth username
    # 
    # 
    # 
    # Requires features basic_auth.
    Puppet::Resource::Param(Any, 'basic_auth_username'),

    # HTTP Basic Auth password
    # 
    # 
    # 
    # Requires features basic_auth.
    Puppet::Resource::Param(Any, 'basic_auth_password'),

    # SSH identity file
    # 
    # 
    # 
    # Requires features ssh_identity.
    Puppet::Resource::Param(Any, 'identity'),

    # The remote repository to track
    # 
    # 
    # 
    # Requires features multiple_remotes.
    Puppet::Resource::Param(Any, 'remote'),

    # The configuration directory to use
    # 
    # 
    # 
    # Requires features configuration.
    Puppet::Resource::Param(Any, 'configuration'),

    # The value to be used for the CVS_RSH environment variable.
    # 
    # 
    # 
    # Requires features cvs_rsh.
    Puppet::Resource::Param(Any, 'cvs_rsh'),

    # The value to be used to do a shallow clone.
    # 
    # 
    # 
    # Requires features depth.
    Puppet::Resource::Param(Any, 'depth'),

    # The name of the branch to clone.
    # 
    # 
    # 
    # Requires features branch.
    Puppet::Resource::Param(Any, 'branch'),

    # The Perforce P4CONFIG environment.
    # 
    # 
    # 
    # Requires features p4config.
    Puppet::Resource::Param(Any, 'p4config'),

    # Initialize and update each submodule in the repository.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features submodules.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'submodules'),

    # The action to take if conflicts exist between repository and working copy
    Puppet::Resource::Param(Any, 'conflict'),

    # Trust server certificate
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'trust_server_cert'),

    # Keep local changes on files tracked by the repository when changing revision
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'keep_local_changes'),

    # The specific backend to use for this `vcsrepo`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # bzr
    # : Supports Bazaar repositories
    # 
    #   * Required binaries: `bzr`.
    #   * Supported features: `reference_tracking`.
    # 
    # cvs
    # : Supports CVS repositories/workspaces
    # 
    #   * Required binaries: `cvs`.
    #   * Supported features: `cvs_rsh`, `gzip_compression`, `modules`, `reference_tracking`, `user`.
    # 
    # dummy
    # : Dummy default provider
    # 
    #   * Default for `feature` == `posix`. Default for `operatingsystem` == `windows`.
    # 
    # git
    # : Supports Git repositories
    # 
    #   * Required binaries: `git`.
    #   * Supported features: `bare_repositories`, `branch`, `depth`, `multiple_remotes`, `reference_tracking`, `ssh_identity`, `submodules`, `user`.
    # 
    # hg
    # : Supports Mercurial repositories
    # 
    #   * Required binaries: `hg`.
    #   * Supported features: `basic_auth`, `reference_tracking`, `ssh_identity`, `user`.
    # 
    # p4
    # : Supports Perforce depots
    # 
    #   * Supported features: `filesystem_types`, `p4config`, `reference_tracking`.
    # 
    # svn
    # : Supports Subversion repositories
    # 
    #   * Required binaries: `svn`, `svnadmin`, `svnlook`.
    #   * Supported features: `basic_auth`, `configuration`, `conflict`, `depth`, `filesystem_types`, `include_paths`, `reference_tracking`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['path']
  },
  true,
  false)
