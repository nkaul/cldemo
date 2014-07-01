class monitoring::puppet {
  package { 'puppet':
    ensure => present
  }
  service { 'puppet':
    ensure  => running,
    enable  => true
  }
}
