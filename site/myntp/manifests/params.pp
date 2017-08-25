class myntp::params {
  case $::facts['os']['family'] {
    'RedHat': {
      $servers = [
        'time.microsoft.com',
        'time.apple.com',
      ]
    }
    default: {
      fail("${module_name} does not support ${::facts['os']['family']}")
    }
  }
}
