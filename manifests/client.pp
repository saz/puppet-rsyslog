# == Class: rsyslog::client
#
# Full description of class role here.
#
# === Parameters
#
# [*log_remote*]
# [*spool_size*]
# [*spool_timeoutenqueue*]
# [*remote_type*]
# [*remote_forward_format*]
# [*log_local*]
# [*log_local_custom*]
# [*log_auth_local*]
# [*listen_localhost*]
# [*custom_config*]
# [*custom_params*]
# [*server*]
# [*port*]
# [*remote_servers*]
# [*ssl_ca*]
# [*ssl_permitted_peer*]
# [*ssl_
# [*log_templates*]
# [*log_filters*]
# [*actionfiletemplate*]
# [*rate_limit_burst*]
# [*rate_limit_interval*]
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::client': }
#
class rsyslog::client (
  $log_remote                = true,
  $spool_size                = '1g',
  $spool_timeoutenqueue      = false,
  $remote_type               = 'tcp',
  $remote_forward_format     = 'RSYSLOG_ForwardFormat',
  $log_local                 = false,
  $log_local_custom          = undef,
  $log_auth_local            = false,
  $listen_localhost          = false,
  $split_config              = false,
  $custom_config             = undef,
  $custom_params             = undef,
  $server                    = 'log',
  $port                      = '514',
  $remote_servers            = false,
  $ssl_ca                    = undef,
  $ssl_permitted_peer        = undef,
  $ssl_auth_mode             = 'anon',
  $log_templates             = false,
  $log_filters               = false,
  $actionfiletemplate        = false,
  $high_precision_timestamps = false,
  $rate_limit_burst          = undef,
  $rate_limit_interval       = undef,
  $imfiles                   = undef
) inherits rsyslog {

  if $custom_config {
    $content_real = template($custom_config)
  } elsif !$split_config {
    $content_real = template(
      "${module_name}/client/config.conf.erb",
      "${module_name}/client/remote.conf.erb",
      "${module_name}/client/local.conf.erb"
    )
  } else {
    $content_real = undef
  }

  if $content_real {
    rsyslog::snippet { $rsyslog::client_conf:
      ensure  => present,
      content => $content_real,
    }
  } else {
    if $remote_servers or $log_remote {
      $_remote_ensure = 'present'
    } else {
      $_remote_ensure = 'absent'
    }

    if $log_auth_local or $log_local {
      $_local_ensure = 'present'
    } else {
      $_local_ensure = 'absent'
    }

    rsyslog::snippet { "00_${rsyslog::client_conf}_config":
      ensure  => present,
      content => template("${module_name}/client/config.conf.erb"),
    }

    rsyslog::snippet { "50_${rsyslog::client_conf}_remote":
      ensure  => $_remote_ensure,
      content => template("${module_name}/client/remote.conf.erb"),
    }

    rsyslog::snippet { "99_${rsyslog::client_conf}_local":
      ensure  => $_local_ensure,
      content => template("${module_name}/client/local.conf.erb"),
    }
  }

  if $rsyslog::ssl and $ssl_ca == undef {
    fail('You need to define $ssl_ca in order to use SSL.')
  }

  if $rsyslog::ssl and $remote_type != 'tcp' {
    fail('You need to enable tcp in order to use SSL.')
  }

  if $ssl_auth_mode != 'anon' and $rsyslog::ssl == false {
    fail('You need to enable SSL in order to use ssl_auth_mode.')
  }

  if $ssl_permitted_peer and $ssl_auth_mode != 'x509/name' {
    fail('You need to set auth_mode to \'x509/name\' in order to use ssl_permitted_peers.')
  }

  if $imfiles {
    create_resources(rsyslog::imfile, $imfiles)
  }

}
