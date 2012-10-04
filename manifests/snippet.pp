define rsyslog::snippet(
  $content,
  $ensure = 'present'
) {
  include rsyslog

  file { "${rsyslog::params::rsyslog_d}${name}":
    ensure  => $ensure,
    owner   => $rsyslog::params::run_user,
    group   => $rsyslog::params::run_group,
    content => $content,
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }
}
