class monitoring::webhost {
  package { 'apache2':
    ensure => installed
  }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/ganglia.lab.local':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('monitoring/ganglia.lab.local.erb'),
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/sites-enabled/ganglia.lab.local':
    ensure  => link,
    target  => '/etc/apache2/sites-available/ganglia.lab.local',
    require => File['/etc/apache2/sites-available/ganglia.lab.local'],
  }

  file { '/var/www/ganglia-webfrontend':
    ensure  => link,
    target  => '/usr/share/ganglia-webfrontend',
    require => Package['ganglia-webfrontend'],
  }

  package { [ 'gmetad', 'ganglia-webfrontend' ]:
    ensure => installed
  }

  service { 'gmetad':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }

  file { '/etc/ganglia/gmetad.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monitoring/gmetad.conf.erb'),
    notify  => Service['gmetad']
  }
}
