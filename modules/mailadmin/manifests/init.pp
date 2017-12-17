# Installs and configures the PHP application
# mail-admin, without any webserver configuration.
class mailadmin(
  $ensure            = present,
  $datadir           = Undef,
  $ldap_base_dn      = Undef,
  $ldap_search_dn    = Undef,
  $ldap_search_pw    = Undef,
  $ldap_dn_string    = Undef,
  $ldap_query_string = Undef,
) {
  validate_string($datadir, $ldap_base_dn, $ldap_search_dn, $ldap_search_pw, $ldap_dn_string, $ldap_query_string);

  vcsrepo { $datadir:
    ensure   => $ensure,
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://github.com/droidwiki/mail-admin.git',
  }

  file { "${datadir}/config/packages/security.yaml":
    ensure  => 'present',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('mailadmin/config/packages/security.yaml'),
  }

  file { "${datadir}/config/services.yaml":
    ensure  => 'present',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('mailadmin/config/services.yaml'),
  }
}
