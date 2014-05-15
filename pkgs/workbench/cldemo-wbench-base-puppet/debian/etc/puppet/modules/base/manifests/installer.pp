class monitoring::installer {
  package { 'tftpd-hpa':
    ensure => installed,
  }
  service { 'tftpd-hpa':
    ensure     => running,
    enabled    => true,
    hasstatus  => true,
    hasrestart => true
  }
  file { '/etc/default/tftpd-hpa':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/base/tftpd-hpa',
    notify => Service['tftpd-hpa']
  }
}
