# == Class: rsyslog::server
#
# This class configures rsyslog for a server role.
#
# === Parameters
#
# [*enable_tcp*]
# [*enable_udp*]
# [*enable_onefile*]
# [*server_dir*]
# [*custom_config*]
# [*high_precision_timestamps*]
#
# === Variables
#
# === Examples
#
#  Defaults
#
#  class { 'rsyslog::server': }
#
#  Create seperate directory per host
#
#  class { 'rsyslog::server':
#    custom_config => 'rsyslog/server-hostname.conf.erb'
#  }
#
class rsyslog::server (
  $enable_tcp                = true,
  $enable_udp                = true,
  $enable_onefile            = false,
  $server_dir                = '/srv/log',
  $custom_config             = undef,
  $high_precision_timestamps = false
) inherits rsyslog {

  $real_content = $custom_config ? {
    ''      => template("${module_name}/server-default.conf.erb"),
    default => template($custom_config),
  }

  file { $rsyslog::server_conf:
    ensure  => present,
    owner   => 'root',
    group   => $rsyslog::run_group,
    content => $real_content,
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }
}
