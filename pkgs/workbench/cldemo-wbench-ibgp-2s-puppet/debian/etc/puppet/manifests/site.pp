
node 'leaf1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.1'
    $int_layer3 = {
        swp1  => { 'address' => '10.1.1.1', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2  => { 'address' => '10.1.1.5', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3  => { 'address' => '10.1.1.9', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4  => { 'address' => '10.1.1.13', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.1.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25 , 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.1.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp34','swp35','swp36','swp37'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'leaf2', asn => 65000, peers => [ '10.1.1.2','10.1.1.6','10.1.1.10','10.1.1.14' ] } ]
    }
    $hostnetranges = [ '10.4.0.0/16' ]
    include ibgp::role::switchbase
}

node 'leaf2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.2'
    $int_layer3 = {
        swp1  => { 'address' => '10.1.1.2', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp2  => { 'address' => '10.1.1.6', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp3  => { 'address' => '10.1.1.10', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
        swp4  => { 'address' => '10.1.1.14', 'netmask' => '255.255.255.252', 'cidr_netmask' => 30 },
    }
    $int_bridges = {
        br0 => { 'address' => '10.4.2.1', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.2.129', 'netmask' => '255.255.255.128', 'cidr_netmask' => 25, 'members' => ['swp34','swp35','swp36','swp37'] }
    }
    $bgp = {
        myasn => 65000,
        peergroupv4 => [ { name => 'leaf1', asn => 65000, peers => [ '10.1.1.1', '10.1.1.5', '10.1.1.9', '10.1.1.13' ] } ]
    }
    $hostnetranges = [ '10.4.0.0/16' ]
    include ibgp::role::switchbase
}
