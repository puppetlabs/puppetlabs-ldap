# == Class: ldap
#
# Puppet module to manage client for LDAP
#
#
# === Parameters
#
#  [uri]
#    Ldap URI as a string. Multiple values can be set
#    separated by spaces ('ldap://ldapmaster ldap://ldapslave')
#    **Required**
#
#  [base]
#    Ldap base dn.
#    **Required**
#
#  [version]
#    Ldap version for the connecting client
#    *Optional* (defaults to 3)
#
#  [timelimit]
#    Time limit in seconds to use when performing searches
#    *Optional* (defaults to 30)
#
#  [bind_timelimit]
#    *Optional* (defaults to 30)
#
#  [idle_timelimit]
#    *Optional* (defaults to 30)
#
#  [binddn]
#    Default bind dn to use when performing ldap operations
#    *Optional* (defaults to false)
#
#  [bindpw]
#    Password for default bind dn
#    *Optional* (defaults to false)
#
#  [ssl]
#    Enable TLS/SSL negotiation with the server
#    *Requires*: tls_cacert parameter
#    *Optional* (defaults to false)
#
#  [nsswitch]
#    If enabled (nsswitch => true) enables nsswitch to use
#    ldap as a backend for password, group and shadow databases.
#    *Requires*: https://github.com/torian/puppet-nsswitch.git (in alpha)
#    *Optional* (defaults to false)
#
#  [nss_passwd]
#    Search base for the passwd database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [nss_group]
#    Search base for the group database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [nss_shadow]
#    Search base for the shadow database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [ensure]
#    *Optional* (defaults to 'present')
#
#  [nslcd]
#    If you are going to use nslcd. (defaults to false)

# === See README for examples
#
class ldap(
  $uri,
  $base,
  $version        = '3',
  $timelimit      = 30,
  $bind_timelimit = 30,
  $idle_timelimit = 60,
  $binddn         = false,
  $bindpw         = false,
  $ssl            = false,
  $tls_cacert     = undef,
  $tls_reqcert    = 'never',
  $nsswitch       = false,
  $nss_passwd     = false,
  $nss_group      = false,
  $nss_shadow     = false,
  $filter         = false,
  $package        = $ldap::params::package,
) inherits ldap::params {

  include ldap::params

  package { $package: ensure => $ensure, }

  File {
    ensure  => $ensure,
    mode    => '0644',
    owner   => $ldap::params::owner,
    group   => $ldap::params::group,
  }

  file { $ldap::params::prefix:
    ensure  => directory,
    require => Package[$package],
  }

  file { "${ldap::params::prefix}/${ldap::params::config}": content => template('ldap/ldap.conf.erb'), }
}
