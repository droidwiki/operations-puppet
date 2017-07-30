# SHorthand class for installing nodejs and npm
class role::nodejs {
  class { '::nodejs':
    manage_package_repo       => true,
    repo_url_suffix           => '6.x',
  }
}
