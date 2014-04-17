class demo1::interfaces {
    file { '/etc/network/interfaces':
            owner   => root,
            group   => root,
            mode    => '0644',
            content => template('demo1/interfaces.erb')
    }

    service { 'networking':
            ensure     => running,
            subscribe  => File['/etc/network/interfaces'],
            hasrestart => true,
            enable     => true,
            hasstatus  => false
    }

}
