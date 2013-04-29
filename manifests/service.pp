# == Class: rsyslog::service
#
# This class enforces running of the rsyslog service.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::service': }
#
class rsyslog::service {
  service { $rsyslog::service_name:
    ensure  => running,
    enable  => true,
    require => Class['rsyslog::config'],
  }
}
