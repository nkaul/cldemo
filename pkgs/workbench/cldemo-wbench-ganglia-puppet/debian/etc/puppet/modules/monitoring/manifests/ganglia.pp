class monitoring::ganglia {
  package { 'ganglia-monitor':
    ensure => installed
  }

  service { 'ganglia-monitor':
    ensure     => running,
    hasstatus  => false,
    hasrestart => true,
    enabled    => true
  }

  file { '/etc/ganglia/gmond.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/monitoring/gmond.conf',
    notify => Service['ganglia-monitor']
  }

}
