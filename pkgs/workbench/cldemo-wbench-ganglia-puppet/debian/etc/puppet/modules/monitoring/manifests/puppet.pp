class monitoring::puppet {
  service { 'puppet':
    ensure  => running,
    enable => true
  }
}
