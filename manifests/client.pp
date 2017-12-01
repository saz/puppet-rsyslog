# == Class: rsyslog::client
#
# Manages rsyslog as client
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
# [*split_config*]
# [*custom_config*]
# [*custom_params*]
# [*server*]
# [*port*]
# [*remote_servers*]
# [*ssl*]
# [*ssl_ca*]
# [*ssl_cert*]
# [*ssl_key*]
# [*ssl_permitted_peer*]
# [*ssl_auth_mode*]
# [*log_templates*]
# [*log_filters*]
# [*actionfiletemplate_cust*]
# [*actionfiletemplate*]
# [*high_precision_timestamps*]
# [*msg_reduction*]
# [*imfiles*]
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
  $disable_xconsole          = false,
  $log_local_custom          = undef,
  $log_auth_local            = false,
  $listen_localhost          = false,
  $split_config              = false,
  $custom_config             = undef,
  $custom_params             = undef,
  $server                    = 'log',
  $port                      = '514',
  $remote_servers            = false,
  $ssl                       = false,
  $ssl_ca                    = undef,
  $ssl_cert                  = undef,
  $ssl_key                   = undef,
  $ssl_permitted_peer        = undef,
  $ssl_auth_mode             = 'anon',
  $log_templates             = false,
  $log_filters               = false,
  $actionfiletemplate_cust   = false,
  $actionfiletemplate        = false,
  $high_precision_timestamps = false,
  $msg_reduction             = false,
  $imfiles                   = undef
) inherits rsyslog::params {
  include ::rsyslog

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
    rsyslog::snippet { '00_client':
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

    # remove old client.conf file
    file { "${rsyslog::params::rsyslog_d}client.conf":
      ensure => absent,
    }

    rsyslog::snippet { '00_client_config':
      ensure  => present,
      content => template("${module_name}/client/config.conf.erb"),
    }

    rsyslog::snippet { '50_client_remote':
      ensure  => $_remote_ensure,
      content => template("${module_name}/client/remote.conf.erb"),
    }

    rsyslog::snippet { '99_client_local':
      ensure  => $_local_ensure,
      content => template("${module_name}/client/local.conf.erb"),
    }
  }

  if $ssl and $ssl_ca == undef {
    fail('You need to define $ssl_ca in order to use SSL.')
  }

  if $ssl and $remote_type != 'tcp' {
    fail('You need to enable tcp in order to use SSL.')
  }

  if $ssl_auth_mode != 'anon' and $ssl == false {
    fail('You need to enable SSL in order to use ssl_auth_mode.')
  }

  if $ssl_permitted_peer and $ssl_auth_mode != 'x509/name' {
    fail('You need to set auth_mode to \'x509/name\' in order to use ssl_permitted_peers.')
  }

  if $ssl and ($ssl_cert and ! $ssl_key) or (! $ssl_cert and $ssl_key) {
    fail('If using client side certificates, you must define both the cert and the key.')
  }

  if $imfiles {
    create_resources(rsyslog::imfile, $imfiles)
  }

}
