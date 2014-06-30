class monitoring::role::gangliawbench {
    include monitoring::puppet,
      monitoring::gangliawebhost

    class {'monitoring::ganglia':
      gangliatype => 'wbench'
    }
}
