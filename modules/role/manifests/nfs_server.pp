# Manages the configuration of the NFS server for shared data.
class role::nfs_server {
  class { '::nfs':
    server_enabled => true
  }
  nfs::server::export{ '/data/shareddata':
    ensure  => 'mounted',
    clients => '172.16.0.2(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}
