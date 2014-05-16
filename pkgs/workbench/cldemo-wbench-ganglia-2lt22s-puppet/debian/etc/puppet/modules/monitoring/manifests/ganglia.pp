class monitoring::ganglia {
  package { 'ganglia-monitor':
    ensure => installed
  }

  service { 'gmond':
    ensure     => running,
    name       => ganglia-monitor,
    hasstatus  => false,
    hasrestart => true,
    enable     => true
  }

  file { '/etc/ganglia/gmond.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/monitoring/gmond.conf',
    notify => Service['gmond']
  }

}
