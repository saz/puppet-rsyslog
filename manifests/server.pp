# == Class: rsyslog::server
#
# This class configures rsyslog for a server role.
#
# === Parameters
#
# [*enable_tcp*]
# [*enable_udp*]
# [*enable_relp*]
# [*remote_ruleset_tcp*]
# [*remote_ruleset_udp*]
# [*remote_ruleset_relp*]
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
# [*ssl_permitted_peer*]
# [*ssl_auth_mode*]
# [*log_templates*]
# [*log_filters*]
# [*actionfiletemplate_cust*]
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
  $remote_ruleset_tcp        = true,
  $remote_ruleset_udp        = true,
  $remote_ruleset_relp       = true,
  $enable_onefile            = false,
  $relay_server              = false,
  $server_dir                = '/srv/log/',
  $custom_config             = undef,
  $content                   = undef,
  $port                      = '514',
  $relp_port                 = '20514',
  $address                   = '*',
  $high_precision_timestamps = false,
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
  $rotate                    = undef,
  $rules                     = undef
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

  # Remove old server.conf file
  file { "${rsyslog::params::rsyslog_d}server.conf":
    ensure => absent,
  }

  rsyslog::snippet { '00_server':
    ensure  => present,
    content => $real_content,
  }

  if $ssl and (!$enable_tcp or $ssl_ca == undef or $ssl_cert == undef or $ssl_key == undef) {
    fail('You need to define all the ssl options and enable tcp in order to use SSL.')
  }

  if $ssl_auth_mode != 'anon' and $ssl == false {
    fail('You need to enable SSL in order to use ssl_auth_mode.')
  }

  if $ssl_permitted_peer and $ssl_auth_mode != 'x509/name' {
    fail('You need to set auth_mode to \'x509/name\' in order to use ssl_permitted_peers.')
  }
}
