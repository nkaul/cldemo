class monitoring::role::wbench {
    include monitoring::puppet,
      netboot::installer,
      monitoring::webhost
}
