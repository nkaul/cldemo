class monitoring::puppet {
  service { 'puppet':
    ensure  => running,
    enabled => true
  }
}
