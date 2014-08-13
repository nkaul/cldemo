node 'spine1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.3'
    $int_layer3 = {
        swp1  => { 'address' => '10.1.1.2', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2  => { 'address' => '10.1.1.6', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3  => { 'address' => '10.1.1.10', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4  => { 'address' => '10.1.1.14', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp17 => { 'address' => '10.1.1.50', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp18 => { 'address' => '10.1.1.54', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp19 => { 'address' => '10.1.1.58', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp20 => { 'address' => '10.1.1.62', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = { }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'leafs', asn => 65000, peers => [ '10.1.1.1','10.1.1.5','10.1.1.9','10.1.1.13','10.1.1.49','10.1.1.53','10.1.1.57','10.1.1.61' ] } ]
    }

    include ibgp::role::switchbase
}

node 'spine2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.4'
    $int_layer3 = {
        swp1 => { 'address' => '10.1.1.18', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2 => { 'address' => '10.1.1.22', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3 => { 'address' => '10.1.1.26', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4 => { 'address' => '10.1.1.30', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp17 => { 'address' => '10.1.1.34', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp18 => { 'address' => '10.1.1.38', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp19 => { 'address' => '10.1.1.42', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp20 => { 'address' => '10.1.1.46', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = { }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'leafs', asn => 65000, peers => [ '10.1.1.17','10.1.1.21','10.1.1.25','10.1.1.29','10.1.1.33','10.1.1.37','10.1.1.41','10.1.1.45' ] } ]
    }

    include ibgp::role::switchbase
}

node 'leaf1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.1'
    $int_layer3 = {
        swp1  => { 'address' => '10.1.1.1', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2  => { 'address' => '10.1.1.5', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3  => { 'address' => '10.1.1.9', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4  => { 'address' => '10.1.1.13', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp17 => { 'address' => '10.1.1.33', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp18 => { 'address' => '10.1.1.37', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp19 => { 'address' => '10.1.1.41', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp20 => { 'address' => '10.1.1.45', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.1.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25 , 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.1.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp34','swp35','swp36','swp37'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'spines', asn => 65000, peers => [ '10.1.1.2','10.1.1.6','10.1.1.10','10.1.1.14','10.1.1.34','10.1.1.38','10.1.1.42','10.1.1.46' ] } ]
    }

    include ibgp::role::switchbase
}

node 'leaf2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.2'
    $int_layer3 = {
        swp1  => { 'address' => '10.1.1.17', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2  => { 'address' => '10.1.1.21', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3  => { 'address' => '10.1.1.25', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4  => { 'address' => '10.1.1.29', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp17 => { 'address' => '10.1.1.49', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp18 => { 'address' => '10.1.1.53', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp19 => { 'address' => '10.1.1.57', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp20 => { 'address' => '10.1.1.61', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 }
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.2.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.2.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp34','swp35','swp36','swp37'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'spines', asn => 65000, peers => [ '10.1.1.18','10.1.1.22','10.1.1.26','10.1.1.30','10.1.1.50','10.1.1.54','10.1.1.58','10.1.1.62' ] } ]
    }

    include ibgp::role::switchbase
}
