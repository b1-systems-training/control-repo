# Cheap demo to show off windows-specific modules
class profile::windemo {
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

  # Some random registry resource, ripped from the registry modules'
  # README

  # Create a registry key
  registry_key { 'HKLM\System\CurrentControlSet\Services\Puppet':
    ensure => present,
  }
  # Create a registry value in a preexisting key
  registry_value { 'HKLM\System\CurrentControlSet\Services\Puppet\Description':
    ensure => present,
    type   => string,
    data   => "The Puppet Agent service periodically manages your configuration",
  }

  # Manage registry value and parent key in one go 
  #registry::value { 'puppetmaster':
  #  key  => 'HKLM\Software\Vendor\PuppetLabs',
  #  data => 'puppet.puppetlabs.com',
  #}

  ## Set a default value
  #registry::value { 'Setting0':
  #  key   => 'HKLM\System\CurrentControlSet\Services\Puppet',
  #  value => '(default)',
  #  data  => "Hello World!",
  #}
}
