# Class: cldemo_ldif_user_data
#
# Load users.ldif into the LDAP server
#
class cldemo_ldif_user_data {

  file { '/usr/local/etc/users.ldif':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => 'puppet:///modules/cldemo_ldif_user_data/users.ldif',
    notify  => Exec['reload_userdata'],
    require => Service['slapd'],
  }

  exec { 'reload_userdata':
    command     => '/usr/local/bin/reload_userdata.sh /usr/local/etc/users.ldif',
    refreshonly => true,
    require     => [ Package['ldap-utils'], Service['slapd'] ],
    subscribe   => Package['slapd']
  }

}

