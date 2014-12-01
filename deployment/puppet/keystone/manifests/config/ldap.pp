#
# This class implements a config fragment for
# the ldap specific backend for keystone.
#
# == Dependencies
# == Examples
# == Authors
#
#   Dan Bode dan@puppetlabs.com
#
# == Copyright
#
# Copyright 2012 Puppetlabs Inc, unless otherwise noted.
#
class keystone::ldap(
  $url            = 'ldap://localhost',
  $user           = 'dc=Manager,dc=example,dc=com',
  $password       = 'None',
  $suffix         = 'cn=example,cn=com',
  $user_tree_dn   = 'ou=Users,dc=example,dc=com',
  $tenant_tree_dn = 'ou=Roles,dc=example,dc=com',
  $role_tree_dn   = 'dc=example,dc=com'
) {

  keystone_config {
    'ldap/url':            value => $url;
    'ldap/user':           value => $user;
    'ldap/password':       value => $password;
    'ldap/suffix':         value => $suffix;
    'ldap/user_tree_dn':   value => $user_tree_dn;
    'ldap/tenant_tree_dn': value => $tenant_tree_dn;
    'ldap/role_tree_dn':   value => $role_tree_dn;
    #"ldap/tree_dn" value => "dc=example,dc=com",
  }
}

class keystone::config::ldap(
  $url            = $::fuel_settings['keystone_ldap']['ldap_url'],
  $suffix         = $::fuel_settings['keystone_ldap']['ldap_suffix'],
  $user           = $::fuel_settings['keystone_ldap']['ldap_user'],
  $password       = $::fuel_settings['keystone_ldap']['ldap_pass'],
  $user_tree_dn   = $::fuel_settings['keystone_ldap']['ldap_user_tree_dn'],
  $user_objectclass    = $::fuel_settings['keystone_ldap']['ldap_user_objectclass'],
  $user_id_attribute   = $::fuel_settings['keystone_ldap']['ldap_user_id_attribute'],
  $user_mail_attribute = $::fuel_settings['keystone_ldap']['ldap_user_mail_attribute'],
  $user_pass_attribute = $::fuel_settings['keystone_ldap']['ldap_user_pass_attribute'],
  $user_enabled_attribute = $::fuel_settings['keystone_ldap']['ldap_user_enabled_attribute'],
  $ldap_driver    = 'keystone.identity.backends.ldap.Identity',
) {

  if ! defined(Package['python-ldap']) {
    package { 'python-ldap': ensure => installed, }

    Package['python-ldap'] -> Keystone_config<||>
  }

  keystone_config {
    'ldap/url':				value => $url;
    'ldap/suffix':			value => $suffix;
    'ldap/user':			value => "'${user}'";
    'ldap/password':			value => $password;
    'ldap/user_tree_dn':		value => "'${user_tree_dn}'";
    'ldap/user_objectclass':		value => "'${user_objectclass}'";
    'ldap/user_id_attribute':		value => "'${user_id_attribute}'";
    'ldap/user_mail_attribute':		value => "'${user_mail_attribute}'";
    'ldap/user_pass_attribute':		value => "'${user_pass_attribute}'";
    'ldap/user_enabled_attribute':	value => "'${user_enabled_attribute}'";
    'identity/driver':			value => $ldap_driver;
  }
}
