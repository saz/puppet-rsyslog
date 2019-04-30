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
  if $::operatingsystem == "Solaris" {
    service { 'svc:/system/system-log:default':
      ensure  => stopped,
      enable  => false,
      before  => Service[$rsyslog::service_name],
      require => Package[$rsyslog::rsyslog_package_name],
    }
  }
  service { $rsyslog::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => $rsyslog::service_hasstatus,
    hasrestart => $rsyslog::service_hasrestart,
    require    => Class['rsyslog::config'],
  }
}
