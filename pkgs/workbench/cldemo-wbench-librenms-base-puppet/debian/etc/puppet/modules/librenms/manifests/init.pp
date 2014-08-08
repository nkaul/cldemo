# == Class: librenms
#
# This class installs & manages LibreNMS, a fork of Observium
#
# == Parameters
#
# [*config*]
#   Configuration for LibreNMS, in a puppet hash format.
#
# [*install_dir*]
#   Installation directory for LibreNMS. Defaults to /srv/librenms.
#
# [*rrd_dir*]
#   Location where RRD files are going to be placed. Defaults to "rrd" under
#   *install_dir*.
#
# Based on puppet from the Wikimedia Foundation

class librenms(
    $config=librenms::params::config,
    $install_dir='/var/www/librenms',
    $rrd_dir="${install_dir}/rrd",
) {
    group { 'librenms':
        ensure => present,
    }

    user { 'librenms':
        ensure     => present,
        gid        => 'librenms',
        shell      => '/bin/false',
        home       => '/nonexistent',
        system     => true,
        managehome => false,
    }

    file { $install_dir:
        ensure  => directory,
        owner   => 'www-data',
        group   => 'librenms',
        mode    => '0555',
        require => Group['librenms'],
    }

    #     file { "${install_dir}/config.php":
    #         ensure  => present,
    #         owner   => 'www-data',
    #         group   => 'librenms',
    #         mode    => '0440',
    #         content => template('librenms/config.php.erb'),
    #         require => Group['librenms'],
    #     }
    #
    file { "${install_dir}/rrd":
      ensure  => directory,
      owner   => 'www-data',
      group   => 'librenms',
      mode    => '0775',
      require => Group['librenms'],
    }

    file { '/etc/apache2/sites-available/librenms.conf':
        ensure  => present,
        owner   => 'www-data',
        group   => 'librenms',
        mode    => '0664',
        content => template('librenms/librenms.conf.erb'),
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/sites-enabled/librenms.conf':
      ensure  => link,
      owner   => 'www-data',
      group   => 'librenms',
      mode    => '0664',
      target  => '/etc/apache2/sites-available/librenms.conf',
      require => File['/etc/apache2/sites-available/librenms.conf'],
    }

  file { '/etc/apache2/sites-enabled/15-default.conf':
    ensure => absent,
    notify => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => absent,
    notify => Service['apache2']
  }

    package { [
            'apache2',
            'libapache2-mod-php5',
            'php5-cli',
            'php5-gd',
            'php5-json',
            'php5-mcrypt',
            'php5-mysql',
            'php5-snmp',
            'php-net-ipv4',
            'php-net-ipv6',
            'php-pear',
            'fping',
            'git',
            'graphviz',
            'imagemagick',
            'ipmitool',
            'mtr-tiny',
            'nmap',
            'python-mysqldb',
            'rrdtool',
            'snmp',
            'snmp-mibs-downloader',
            'snmpd',
            'whois',
        ]:
        ensure => present,
    }

    exec { "a2enmod rewrite":
      refreshonly => true,
      subscribe   => Package['apache2'],
      require     => Package['apache2'],
    }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['apache2'],
  }
#     cron { 'librenms-discovery-all':
#         ensure  => present,
#         user    => 'librenms',
#         command => "${install_dir}/discovery.php -h all >/dev/null 2>&1",
#         hour    => '*/6',
#         minute  => '33',
#         require => User['librenms'],
#     }
#     cron { 'librenms-discovery-new':
#         ensure  => present,
#         user    => 'librenms',
#         command => "${install_dir}/discovery.php -h new >/dev/null 2>&1",
#         minute  => '*/5',
#         require => User['librenms'],
#     }
#     cron { 'librenms-poller-all':
#         ensure  => present,
#         user    => 'librenms',
#         command => "python ${install_dir}/poller-wrapper.py 16 >/dev/null 2>&1",
#         minute  => '*/5',
#         require => User['librenms'],
#     }
#
    # syslog script, in an install_dir-agnostic location
    # used by librenms::syslog or a custom alternative placed manually.
    file { '/usr/local/sbin/librenms-syslog':
        ensure => link,
        target => "${install_dir}/syslog.php",

    }

  class { '::mysql::server':
    root_password   => 'password',
    service_enabled => true,
  }

  mysql::db { 'librenms':
    user     => 'librenms',
    password => 'password',
    host     => 'localhost',
    grant    => 'ALL',
  }

}
