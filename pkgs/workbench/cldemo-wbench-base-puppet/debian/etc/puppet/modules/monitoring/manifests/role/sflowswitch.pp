class monitoring::role::gangliaswitch {
    include base::role::switch,
      base::ptm,
      ospfunnum::quagga,
      monitoring::hsflowd
}
