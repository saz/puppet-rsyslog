# == Class: rsyslog::server
#
# This class configures rsyslog for a server role.
#
# === Parameters
#
# [*enable_tcp*]
# [*enable_udp*]
# [*enable_onfile*]
# [*server_dir*]
# [*custom_config*]
# [*high_precision_timestamps*]
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::server': }
#
class rsyslog::server (
  $enable_tcp                = true,
  $enable_udp                = true,
  $enable_onfile             = false,
  $server_dir                = '/srv/log/',
  $custom_config             = undef,
  $high_precision_timestamps = false
) inherits rsyslog {

  $real_content = $custom_config ? {
    ''      => template("${module_name}/server.conf.erb"),
    default => template($custom_config),
  }

  file { $rsyslog::params::server_conf:
    ensure  => present,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    content => $real_content,
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }
}
