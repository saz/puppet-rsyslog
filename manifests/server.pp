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
# [*ssl*]
# [*ssl_ca*]
# [*ssl_cert*]
# [*ssl_key*]
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
  $high_precision_timestamps = false,
  $ssl                       = false,
  $ssl_ca                    = undef,
  $ssl_cert                  = undef,
  $ssl_key                   = undef,
) inherits rsyslog {

  $real_content = $custom_config ? {
    ''      => template("${module_name}/server-default.conf.erb"),
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

  #  if $ssl and $enable_tcp and $ssl_ca != undef and $ssl_cert != undef and $ssl_key != undef {
  #  fail('You need to define all the ssl options and enable tcp in order to use SSL.')
  #}
}
