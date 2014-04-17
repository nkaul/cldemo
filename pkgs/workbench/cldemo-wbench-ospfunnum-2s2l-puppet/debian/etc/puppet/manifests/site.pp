node "spine1.lab.local" {
    $int_loopback = "10.2.1.3"
    $int_unnumbered = [ "swp1", "swp2", "swp3", "swp4", "swp17", "swp18", "swp19", "swp20" ]
    $int_bridges = { }
    include switchbase
}
 
node "spine2.lab.local" {
    $int_loopback = "10.2.1.4"
    $int_unnumbered = [ "swp1", "swp2", "swp3", "swp4", "swp17", "swp18", "swp19", "swp20" ]
    $int_bridges = { }
    include switchbase
}
 
node "leaf1.lab.local" {
        $int_loopback = "10.2.1.1"
        $int_unnumbered = [ "swp1", "swp2", "swp3", "swp4", "swp17", "swp18", "swp19", "swp20" ]
    $int_bridges = {
        br0 => { 'address' => '10.4.1.1', 'netmask' => '255.255.255.128', 'members' => ['swp30','swp31','swp32','swp33'] },
        br1 => { 'address' => '10.4.1.129', 'netmask' => '255.255.255.128', 'members' => ['swp34','swp35','swp36','swp37'] }
    }
        include switchbase
}
 
node "leaf2.lab.local" {
        $int_loopback = "10.2.1.2"
        $int_unnumbered = [ "swp1", "swp2", "swp3", "swp4", "swp17", "swp18", "swp19", "swp20" ]
        $int_bridges = {
                br0 => { 'address' => '10.4.2.1', 'netmask' => '255.255.255.128', 'members' => ['swp30','swp31','swp32','swp33'] },
                br1 => { 'address' => '10.4.2.129', 'netmask' => '255.255.255.128', 'members' => ['swp34','swp35','swp36','swp37'] }
        }
        include switchbase
}
 
class switchbase {
    include license
    include interfaces
    include ptm
    include quagga
    include motd
}
 
 
class interfaces {
    file { "/etc/network/interfaces":
            owner => root,
            group => root,
            mode => 644,
            content => template("demo1/interfaces.erb")
    }
        exec { "/etc/init.d/networking restart":
                subscribe => File["/etc/network/interfaces"],
                refreshonly => true
        }
}
 
class quagga {
    service { 'quagga': ensure=> running, enable => true }
    file { "/etc/quagga/daemons":
        owner => quagga,
        group => quagga,
        source => "puppet:///files/quagga_daemons",
        notify => Service["ptmd"]
    }
    file { "/etc/quagga/Quagga.conf":
        owner => root,
        group => quaggavty,
        mode => 644,
        content => template("demo1/Quagga.conf.erb"),
        notify => Service["ptmd"]
    }
}
 
class ptm {
    service { 'ptmd': ensure=> running, enable => true }
    file { "/etc/cumulus/ptm.d/topology.dot":
        owner => root,
        group => root,
    mode => 644,
        source => "puppet:///files/topology.dot",
    notify => Service["ptmd"]
    }
}
class motd {
    file { "/etc/motd":
        owner => root,
        group => root,
        mode => 644,
        content => template("demo1/motd.erb")
    }
}
 
class license {
    service { 'switchd': ensure=> running, enable => true }
    file { "/etc/cumulus/license.txt":
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///files/cumulus.lic",
        notify => Service["switchd"]
    }
    exec { "/usr/cumulus/bin/cl-license -i /etc/cumulus/license.txt; service switchd restart":
        subscribe => File["/etc/cumulus/license.txt"],
        refreshonly => true
    }
}
