# Cheap demo to show off windows-specific modules
class windemo {
  # Useless? I don't think so!!1
  dism{'TelnetClient':
    ensure    => present,
    norestart => true,
  }
  # Create a reboot resource that may used as a trigger
  reboot{'after_initial_installation':}

  Package {
    ensure   => installed,
    provider => 'chocolatey',
  }

  service{'puppet':
    ensure => running,
    enable => true,
  }

  class {'chocolatey':
    use_7zip                      => false,
    choco_install_timeout_seconds => 2700,
    log_output                    => true,
  }

  Class['chocolatey'] -> Package <| provider == 'chocolatey' |>

  $packages = [
    'classic-shell',
    'sysinternals',
    'check_mk_agent'
  ]

  ensure_packages($packages, { 'notify' => Reboot['after_initial_installation'] })
}
