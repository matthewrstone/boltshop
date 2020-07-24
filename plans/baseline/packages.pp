plan boltshop::baseline::packages(
  TargetSpec $targets
) {
  apply_prep($targets)
  $jobs = apply($targets) {
    lookup('windows::packages').each |$pkg| {
      package { $pkg:
        ensure   => 'present',
        provider => 'chocolatey'
      }
    }
  }
  return $jobs
}
