# == Class: rsyslog::server
#
# This class configures rsyslog for a server role.
#
# === Parameters
#
# [*enable_tcp*]
# [*enable_udp*]
# [*enable_relp*]
# [*enable_onefile*]
# [*relay_server*]
# [*server_dir*]
# [*custom_config*]
# [*content*]
# [*port*]
# [*relp_port*]
# [*address*]
# [*high_precision_timestamps*]
# [*ssl_ca*]
# [*ssl_cert*]
# [*ssl_key*]
# [*log_templates*]
# [*log_filters*]
# [*actionfiletemplate*]
# [*rotate*]
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
  $enable_relp               = true,
  $enable_onefile            = false,
  $relay_server              = false,
  $server_dir                = '/srv/log/',
  $custom_config             = undef,
  $content                   = undef,
  $port                      = '514',
  $relp_port                 = '20514',
  $address                   = '*',
  $high_precision_timestamps = false,
  $ssl_ca                    = undef,
  $ssl_cert                  = undef,
  $ssl_key                   = undef,
  $log_templates             = false,
  $log_filters               = false,
  $actionfiletemplate        = false,
  $rotate                    = undef
) inherits rsyslog::params {
  include ::rsyslog

  ### Logrotate policy
  $logpath = $rotate ? {
    'year'   => '/%$YEAR%/',
    'YEAR'   => '/%$YEAR%/',
    'month'  => '/%$YEAR%/%$MONTH%/',
    'MONTH'  => '/%$YEAR%/%$MONTH%/',
    'day'    => '/%$YEAR%/%$MONTH%/%$DAY%/',
    'DAY'    => '/%$YEAR%/%$MONTH%/%$DAY%/',
    default  => '/',
  }

  if $content {
    if $custom_config {
      fail '$content and $custom_config are mutually exclusive'
    }
    $real_content = $content
  } elsif $custom_config {
    $real_content = template($custom_config)
  } else {
    $real_content = template("${module_name}/server-default.conf.erb")
  }

  rsyslog::snippet { '00_server':
    ensure  => present,
    content => $real_content,
  }

  if $rsyslog::ssl and (!$enable_tcp or $ssl_ca == undef or $ssl_cert == undef or $ssl_key == undef) {
    fail('You need to define all the ssl options and enable tcp in order to use SSL.')
  }
}
