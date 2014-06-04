class monitoring::role::switch {
    include base::role::switch,
      monitoring::hsflowd,
      base::ptm,
      ospfunnum::quagga

    class {'monitoring::ganglia':
      gangliatype => 'switch'
    }
}
