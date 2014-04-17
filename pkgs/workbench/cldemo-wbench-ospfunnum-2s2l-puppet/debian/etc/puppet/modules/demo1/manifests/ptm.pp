class demo1::ptm {
    service { 'ptmd':
        ensure     => running,
        hasrestart => true,
        enable     => true
    }

    file { '/etc/cumulus/ptm.d/topology.dot':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///demo1/topology.dot',
        notify => Service['ptmd']
    }
}
