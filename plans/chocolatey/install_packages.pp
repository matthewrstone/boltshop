plan wsp::chocolatey::install_packages(
  TargetSpec $targets
) {
  apply_prep($targets)
  $result = apply($targets){
    $pkgs = lookup('windows::packages')
    $pkgs.each | $pkg | {
      package { $pkg :
        ensure   => present,
        provider => chocolatey
      }
    }
  }
  return $result
}
