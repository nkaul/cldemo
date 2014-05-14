class monitoring::hsflowd {
  # Warning: this class will not properly work until 2.1
  # You must manually install hsflowd from latest source and
  # use a working beta switchd.deb

  # package hsflowd {
  #   ensure => installed;
  # }

  file { '/etc/hsflowd.conf': 
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'files:///monitoring/hsflowd.conf',
      notify => Service['hsflowd']
  }

  service { 'hsflowd':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }
}
