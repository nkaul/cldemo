class monitoring::webhost {
  package { 'apache2':
    ensure => installed
  }

  service { 'apache2':
    ensure     => running,
    enabled    => true,
    hasrestart => true,
    require    => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/ganglia.lab.local':
    ensure => present,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0644',
    notify => Service['apache2'],
  }

  file { '/etc/apache2/sites-enabled/ganglia.lab.local':
    ensure  => link,
    require => File['/etc/apache2/sites-available/ganglia.lab.local'],
  }

  package { [ 'ganglia-monitor', 'gmetad', 'ganglia-webfrontend' ]:
    ensure => installed
  }

}
