
node 'spine1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.3'
    $int_unnumbered = [ 'swp49', 'swp50', 'swp51', 'swp52' ]
    $int_bridges = { }
    include monitoring::role
}

node 'spine2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.4'
    $int_unnumbered = [ 'swp49', 'swp50', 'swp51', 'swp52' ]
    $int_bridges = { }
    include monitoring::role
}

node 'leaf1.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.1'
    $int_unnumbered = [ 'swp1s0', 'swp1s1', 'swp1s2', 'swp1s3' ]
    $int_bridges = {
        br0 => { 'address' => '10.4.1.1', 'netmask' => '255.255.255.128', 'members' => ['swp32s0'] },
        br1 => { 'address' => '10.4.1.129', 'netmask' => '255.255.255.128', 'members' => ['swp32s1'] }
    }
    include monitoring::role
}

node 'leaf2.lab.local' {
    $int_enabled = true
    $int_loopback = '10.2.1.2'
    $int_unnumbered = [ 'swp1s0', 'swp1s1', 'swp1s2', 'swp1s3' ]
    $int_bridges = {
        br0 => { 'address' => '10.4.2.1', 'netmask' => '255.255.255.128', 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.2.129', 'netmask' => '255.255.255.128', 'members' => ['swp34','swp35','swp36','swp37'] }
    }
    include monitoring::role
}

node 'wbench.lab.local' {
    $data_sources = [ 'spine1.lab.local', 'spine2.lab.local', 'leaf1.lab.local', 'leaf2.lab.local' ]
    include monitoring::role::wbench
}
