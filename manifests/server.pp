# @summary
#   This class manages rsyslog as server
#
# @example Puppet usage
#   Default usage:
#     class { 'rsyslog::server': }
#
#   Create seperate directory per host
#     class { 'rsyslog::server':
#       custom_config => 'rsyslog/server-hostname.conf.erb'
#     }
#
# @param enable_tcp
#   Enable TCP listener
#
# @param enable_udp
#   Enable UDP listener
#
# @param enable_relp
#   Enable RELP listener
#
# @param remote_ruleset_tcp
#   Whether or not the `remote` ruleset should be used for TCP listener
#
# @param remote_ruleset_udp
#   Whether or not the `remote` ruleset should be used for UDP listener
#
# @param remote_ruleset_relp
#   Whether or not the `remote` ruleset should be used for RELP listener
#
# @param enable_onefile
#   Only one logfile per remote host
#
# @param relay_server
#   If the server should be able to relay the received logs to another server. The rsyslog::client must also be set up
#
# @param server_dir
#   Folder where logs will be stored on the server
#
# @param custom_config
#   Specify your own template to use for rsyslog.conf
#
# @param content
#   Instead of using a template to generate rsyslog.conf, use the specified content
#
# @param port
#   Port to listen on for messages via TCP and UDP
#
# @param relp_port
#   Port to listen on for messages via RELP
#
# @param address
#   The IP address to bind to. Applies to UDP listener only
#
# @param high_precision_timestamps
#   Whether or not to use high precision timestamps
#
# @param ssl
#   Enable SSL support
#
# @param ssl_ca
#   SSL CA file location
#
# @param ssl_cert
#   Path to SSL certificate
#
# @param ssl_key
#   Path to SSL private key
#
# @param ssl_permitted_peer
#   List of permitted peers
#
# @param ssl_auth_mode
#   SSL auth mode
#
# @param log_templates
#   Array of hashes defining custom logging templates using the `$template` configuration parameter
#
# @param log_filters
#   Array of hashes defining custom logging filters using the `if/then` configuration parameter
#
# @param actionfiletemplate_cust
#   If set, this defines the `ActionFileDefaultTemplate custom formatting` which sets customisations over the default log format for remote and local logging. Must be used with actionfiletemplate to take effect
#
# @param actionfiletemplate
#   If set, this defines the `ActionFileDefaultTemplate` which sets the default logging format for remote and local logging
#
# @param rotate
#   Enables rotation of logfiles
#
# @param rules
#   Array of hashes for configuring custom rules for the server. If set, this replaces the default rules
#
class rsyslog::server (
  Boolean $enable_tcp = true,
  Boolean $enable_udp = true,
  Boolean $enable_relp = true,
  Boolean $remote_ruleset_tcp = true,
  Boolean $remote_ruleset_udp = true,
  Boolean $remote_ruleset_relp = true,
  Boolean $enable_onefile = false,
  Boolean $relay_server = false,
  Stdlib::Absolutepath $server_dir = '/srv/log',
  Optional[String[1]] $custom_config = undef,
  Optional[String[1]] $content = undef,
  Variant[String[1], Stdlib::Port] $port = '514',
  Variant[String[1], Stdlib::Port] $relp_port = '20514',
  String[1] $address = '*',
  Boolean $high_precision_timestamps = false,
  Boolean $ssl = false,
  Optional[String[1]] $ssl_ca = undef,
  Optional[String[1]] $ssl_cert = undef,
  Optional[String[1]] $ssl_key = undef,
  Optional[String[1]] $ssl_permitted_peer = undef,
  String[1] $ssl_auth_mode = 'anon',
  Array[Hash] $log_templates = [],
  Array[Hash] $log_filters = [],
  Optional[String[1]] $actionfiletemplate_cust = undef,
  Optional[String[1]] $actionfiletemplate = undef,
  Optional[Enum['year', 'YEAR', 'month', 'MONTH', 'day', 'DAY']] $rotate = undef,
  Array[Hash] $rules = [],
) inherits rsyslog::params {
  include rsyslog

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
