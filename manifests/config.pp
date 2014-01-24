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
class rsyslog::config {
  file { $rsyslog::rsyslog_d:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    purge   => $rsyslog::purge_rsyslog_d,
    recurse => true,
    force   => true,
    require => Class['rsyslog::install'],
  }

  file { $rsyslog::rsyslog_conf:
    ensure  => file,
    owner   => 0,
    group   => 0,
    content => template("${module_name}/rsyslog.conf.erb"),
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

  file { $rsyslog::rsyslog_default:
    ensure  => file,
    owner   => 0,
    group   => 0,
    source  => "puppet:///modules/rsyslog/${rsyslog::parmas::default_config_file}",
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

  file { $rsyslog::spool_dir:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

}
