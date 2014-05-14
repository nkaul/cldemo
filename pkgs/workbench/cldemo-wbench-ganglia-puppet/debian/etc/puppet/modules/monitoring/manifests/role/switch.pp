class monitoring::role::switch {
    include base::role::switch,
      monitoring::hsflowd,
      monitoring::ganglia
}
