node 'leaf1' {

  file { '/etc/ldap.conf':
    ensure => link,
    target => '/etc/ldap/ldap.conf'
  }

  class { 'pam::pamd':
    pam_ldap      => true,
    pam_mkhomedir => true,
  }

  class { 'ldap':
    uri        => 'ldap://wbench.lab.local',
    base       => 'dc=lab,dc=local',
    ssl        => false,

    nsswitch   => true,
    nss_passwd => 'ou=users',
    nss_shadow => 'ou=users',
    nss_group  => 'ou=groups',

    pam        => true,
  }

}

node 'wbench' {
  class { 'ldap::server::master':
    suffix => 'dc=lab,dc=local',
    rootpw => 'CumulusLinux!',
  }

  package { 'ldap-utils':
    ensure => installed
  }

  include cldemo_ldif_user_data
}

