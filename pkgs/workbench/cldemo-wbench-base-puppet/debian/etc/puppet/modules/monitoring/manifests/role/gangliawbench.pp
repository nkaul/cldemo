class monitoring::role::gangliawbench {
    include monitoring::puppet,
      monitoring::webhost

    class {'monitoring::ganglia':
      gangliatype => 'wbench'
    }
}
