class monitoring::ganglia {
  package { 'ganglia-monitor':
    ensure => installed
  }

  service { 'gmond':
    ensure     => running,
    name       => ganglia-monitor,
    hasstatus  => true,
    hasrestart => true,
    status     => 'pgrep -u ganglia -f /usr/sbin/gmond',
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

  # include multiple interface module
  file { '/usr/lib/ganglia/python_modules/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/lib/ganglia/python_modules/multi_interface.py':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/usr/lib/ganglia/python_modules/'],
    source  => 'puppet:///modules/monitoring/multi_interface.py',
    notify  => Service['gmond']
  }

  file { '/etc/ganglia/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/ganglia/conf.d/multi_interface.pyconf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/ganglia/conf.d'],
    source  => 'puppet:///modules/monitoring/multi_interface.pyconf',
    notify  => Service['gmond']
  }

}
