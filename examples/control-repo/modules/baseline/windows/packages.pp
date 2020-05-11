# Install Windows Packages
class baseline::windows::packages(){
  lookup('windows::packages').each |$pkg| {
    package { $pkg:
      ensure   => 'present',
      provider => 'chocolatey'
    }
  }
}
