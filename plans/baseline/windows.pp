plan boltshop::baseline::windows(
  TargetSpec $targets
  ) {
  # Leave this commented out. We will use it later for MOTD
  $motd = file::read('boltshop/motd.txt')
  apply_prep($targets)
  # Intro to Bolt Data Types
  # https://puppet.com/docs/bolt/latest/bolt_types_reference.html
  # $jobs will be the ResultSet object from our plan.
  $jobs = apply($targets){
    include chocolatey

    # Managing Windows Power Settings
    # https://forge.puppet.com/puppetlabs/registry
    registry::value { 'Hibernation' :
      key   => "HKLM:\\System\\CurrentControlSet\\Control\\Power\\HibernateEnabled",
      value => 'HibernateEnabled',
      data  => '1',
    }

    # Adding a Scheduled Task
    # https://forge.puppet.com/puppetlabs/scheduled_task
    # scheduled_task { 'Clean Temp Folder Nightly':
    #   command   => "$::system32\\WindoboltshopowerShell\\v1.0\\powershell.exe",
    #   arguments => 'Remove-Item C:\\Temp\\* -Recurse -Force',
    #   enabled   => 'true',
    #   trigger   => [{
    #     schedule   => 'daily',
    #     start_time => '1:00'
    #   }],
    # }

    # SETTING THE LOGON MESSAGE
    # https://forge.puppet.com/puppetlabs/motd
    #
    # VERSION ONE
    # class { 'motd':
    #   windows_motd_title => 'AUTHORIZED USERS ONLY',
    #   content            => "All actions are logged. Use at your own risk!\n",
    # }
    #
    # VERSION TWO
    class { 'motd':
      windows_motd_title => 'AUTHORIZED USERS ONLY',
      content            => $motd,
    }
  }
  return $jobs
}
