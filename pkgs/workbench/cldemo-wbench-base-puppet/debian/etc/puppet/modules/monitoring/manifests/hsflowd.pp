class monitoring::hsflowd {
  # Warning: this class will not properly work until 2.1
  # You must manually install hsflowd from latest source and
  # use a working beta switchd.deb

  package hsflowd {
     ensure => installed;
  }

  service { 'hsflowd':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }
}
