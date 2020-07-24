# Windows Baseline
class baseline::windows(){
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
  scheduled_task { 'Clean Temp Folder Nightly':
    command   => "$::system32\\WindoboltshopowerShell\\v1.0\\powershell.exe",
    arguments => 'Remove-Item C:\\Temp\\* -Recurse -Force',
    enabled   => 'true',
    trigger   => [{
      schedule   => 'daily',
      start_time => '1:00'
    }],
  }

  class { 'motd':
    windows_motd_title => 'AUTHORIZED USERS ONLY',
    content            => file('puppet:///modules/baseline/motd.txt'),
  }
}
