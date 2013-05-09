# == Class: rsyslog::client
#
# Full description of class role here.
#
# === Parameters
#
# [*sample_parameter*]
# [*log_remote*]
# [*spool_size*]
# [*remote_type*]
# [*log_local*]
# [*log_auth_local*]
# [*custom_config*]
# [*custom_params*]
# [*server*]
# [*port*]
# [*ssl*]
# [*ssl_ca*]
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::client': }
#
class rsyslog::client (
  $log_remote           = true,
  $spool_size           = '1g',
  $remote_type   = 'tcp',
  $log_local            = false,
  $log_auth_local       = false,
  $custom_config        = undef,
  $custom_params        = undef,
  $server               = 'log',
  $port                 = '514',
  $ssl                  = false,
  $ssl_ca               = undef,
) inherits rsyslog {

  $content_real = $custom_config ? {
    ''      => template("${module_name}/client.conf.erb"),
    default => template($custom_config),
  }

  file { $rsyslog::params::client_conf:
    ensure  => present,
    owner   => root,
    group   => $rsyslog::params::run_group,
    content => $content_real,
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }
}
