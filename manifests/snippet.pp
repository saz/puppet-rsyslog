define rsyslog::snippet(
  $content,
  $ensure = 'present'
) {
  include rsyslog

  file { "${rsyslog::params::rsyslog_d}${name}.conf":
    ensure  => $ensure,
    owner   => $rsyslog::params::run_user,
    group   => $rsyslog::params::run_group,
    content => "${content}\n",
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }
}
