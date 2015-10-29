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
# [*server_dir*]
# [*custom_config*]
# [*port*]
# [*relp_port*]
# [*address*]
# [*high_precision_timestamps*]
# [*ssl_ca*]
# [*ssl_cert*]
# [*ssl_key*]
# [*log_templates*]
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
  $enable_tcp                = hiera( 'rsyslog::server::enable_tcp',                true ),
  $enable_udp                = hiera( 'rsyslog::server::enable_udp',                true ),
  $enable_relp               = hiera( 'rsyslog::server::enable_relp',               true ),
  $enable_onefile            = hiera( 'rsyslog::server::enable_onefile',            false ),
  $server_dir                = hiera( 'rsyslog::server::server_dir',                '/srv/log/' ),
  $custom_config             = hiera( 'rsyslog::server::custom_config',             undef ),
  $content                   = hiera( 'rsyslog::server::content',                   undef ),
  $port                      = hiera( 'rsyslog::server::port',                      '514' ),
  $relp_port                 = hiera( 'rsyslog::server::relp_port',                 '20514' ),
  $address                   = hiera( 'rsyslog::server::address',                   '*' ),
  $high_precision_timestamps = hiera( 'rsyslog::server::high_precision_timestamps', false ),
  $ssl_ca                    = hiera( 'rsyslog::server::ssl_ca',                    undef ),
  $ssl_cert                  = hiera( 'rsyslog::server::ssl_cert',                  undef ),
  $ssl_key                   = hiera( 'rsyslog::server::ssl_key',                   undef ),
  $log_templates             = hiera( 'rsyslog::server::log_templates',             false ),
  $actionfiletemplate        = hiera( 'rsyslog::server::actionfiletemplate',        false ),
  $rotate                    = hiera( 'rsyslog::server::rotate',                    undef )
) inherits rsyslog {

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
      fail 'Cannot set both $content and $custom_config'
    }
    $real_content = $content
  } elsif $custom_config {
    $real_content = template($custom_config)
  } else {
    $real_content = template("${module_name}/server-default.conf.erb")
  }

  rsyslog::snippet { $rsyslog::server_conf:
    ensure  => present,
    content => $real_content,
  }

  if $rsyslog::ssl and (!$enable_tcp or $ssl_ca == undef or $ssl_cert == undef or $ssl_key == undef) {
    fail('You need to define all the ssl options and enable tcp in order to use SSL.')
  }
}
