class profile::base {
  contain ::ntp
  contain ::ssh
  $ssh_keys = lookup({'name' => 'ssh_keys',
            'merge' => {
              'strategy' => 'deep',
              'knockout_prefix' => '--',
            }
  })
  $ssh_keys_defaults = lookup({'name' => 'ssh_keys_defaults',
            'merge' => {
              'strategy' => 'deep',
              'knockout_prefix' => '--',
            }
  })
  create_resources('ssh_authorized_keys', $ssh_keys, $ssh_keys_defaults)
  
}
