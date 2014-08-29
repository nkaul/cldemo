node 'leaf1.lab.local' {
      include ztpbasic::role::switchbase
}

node 'server1' {
    include ::openstack::role::allinone
}


