# == Class: rsyslog::config
#
# Full description of class role here.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::config': }
#
class rsyslog::config inherits rsyslog::params {
  file { $rsyslog::params::rsyslog_d:
    ensure  => directory,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    recurse => true,
    force   => true,
    require => Class['rsyslog::install'],
  }

  file { $rsyslog::params::rsyslog_conf:
    ensure  => file,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    content => template("${module_name}/rsyslog.conf.erb"),
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

  file { $rsyslog::params::rsyslog_default:
    ensure  => file,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    source  => 'puppet:///modules/rsyslog/rsyslog_default',
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

  file { $rsyslog::params::spool_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }
}
