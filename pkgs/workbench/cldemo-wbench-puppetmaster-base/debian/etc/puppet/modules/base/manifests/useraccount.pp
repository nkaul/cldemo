define base::useraccount($username, $uid, $gid, $enabled=true, $password, $sshkey='', ) {
  user { $username:
    name      => $username,
    uid       => $uid,
    gid       => $gid,
    shell     => '/bin/bash',
    allowdupe => false,
    password  => $password

    if ( $sshkey != '' ) {
      ssh_authorized_key { $title:
        ensure  => 'present',
        type    => 'ssh-rsa',
        key     => '$sshkey',
        user    => '$username',
        require => User['$username'],
        name    => '$username',
      }
    }
  }
}
