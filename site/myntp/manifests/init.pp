class myntp(
  Array $servers = $::myntp::params::servers
) inherits myntp::params {

  file { '/tmp/ntp.conf':
    ensure  => file,
    content => epp('myntp/ntp.conf.epp', { 'ntp_servers' => $servers }),
  }
}
