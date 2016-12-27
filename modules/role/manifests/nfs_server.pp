# Manages the configuration of the NFS server for shared data.
class role::nfs_server {
  class { '::nfs':
    server_enabled => true
  }
  nfs::server::export{ '/data/shareddata':
    ensure  => 'mounted',
    clients => '188.68.49.74(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}
