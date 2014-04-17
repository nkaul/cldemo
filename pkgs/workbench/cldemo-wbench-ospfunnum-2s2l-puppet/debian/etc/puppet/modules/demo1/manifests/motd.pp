class demo1::motd {
    file { '/etc/motd':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('demo1/motd.erb')
    }
}
