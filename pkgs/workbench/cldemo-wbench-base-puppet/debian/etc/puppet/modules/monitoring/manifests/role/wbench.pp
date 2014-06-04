class monitoring::role::wbench {
    include monitoring::puppet,
      monitoring::webhost

    class {'monitoring::ganglia':
      gangliatype => 'wbench'
    }
}
