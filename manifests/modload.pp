# == Class: rsyslog::modload
#

class rsyslog::modload (
  $modload_filename = '10-modload',
) {
  rsyslog::snippet { $modload_filename:
    ensure  => present,
    content => template('rsyslog/modload.erb'),
    require => Class['rsyslog::install'],
  }

}
