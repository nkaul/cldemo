class role::librenms {
  include librenms

  # in a production environment, DO NOT put passwords in the main
  # puppet repository and use strong passwords

  class { '::mysql::server':
    root_password   => 'password',
    service_enabled => 'true',
  }

  mysql::db { 'librenms':
    user     => 'librenms',
    password => 'password',
    host     => 'localhost',
    grant    => 'ALL',
  }
}
