class base::users {

  base::useraccount { 'rocket':
    $username = 'rocket'
    $uid = '600'
    $gid = ['cumulus', 'sudo']
    $sshkey = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0iscDeejPmguBLIKoes6bZrxIq89mW4dfeox9Bhel1qqDVJZjeqgj6MaI53WnNHcLZFzNyIL4wzNvTL9dVIgc3hHissiieFvtK71q9xqbxwYbySq+yKxJMTe+MrbyLpj5XZVDL/E8/xVxP+YIXMpHm9GeMVeyAT/fPRgkXHGWoHsBz7bGJQi6s78NU0gjtIuT2h+mKhSo2ZZrDNjqR11x5AVjZLB304Y3UxNCsuTjozNNu5JqjW2+9QhKWHLI3kUWUz9EjCV77KKS0GbevQo7Mx8D7uQT3IQxbm3UBhK88GnZeRzkP4ULZ5uYkY1D3hiuSAirDBTdT2lHc/iTX7R'
    $password = ''
  }


  base::useraccount { 'turtle':
    $username = 'turtle'
    $uid = '601'
    $gid = ['cumulus', 'sudo']
    #password is tortoise
    $password = '$1$xCoCykA3$V4uw/3rjkKCsNfMXwRWJi0'
  }

  base::sudo_user { ['rocket', 'turtle']:
    privileges => ['ALL = (root) NOPASSWD: ALL']
  }

}
