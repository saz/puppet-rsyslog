# @summary
#   This class manages rsyslog as client
#
# @example Puppet usage
#   class { 'rsyslog::client': }
#
# @param log_remote
#   Log remotely
#
# @param spool_size
#   Max size for disk queue if remote server fails
#
# @param spool_timeoutenqueue
#   Time to wait before discarding on full spool
#
# @param remote_type
#   Which protocol to use for remote logging
#
# @param remote_forward_format
#   Which forward format for remote servers should be used
#
# @param log_local
#   Log locally
#
# @param disable_xconsole
#   Disable messages to /dev/xconsole
#
# @param log_local_custom
#   Define custom local config entries
#
# @param log_auth_local
#   Just log auth facility locally
#
# @param listen_localhost
#   Start a UDP listener on 127.0.0.1:514
#
# @param split_config
#   Splits the client config into 00_client_config.conf, 50_client_remote.conf and 99_client_local.conf
#
# @param custom_config
#   Specify your own template to use for client config
#
# @param server
#   Rsyslog server to log to
#
# @param port
#   Remote server port
#
# @param remote_servers
#   Array of hashes with remote servers
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
# @param high_precision_timestamps
#   Whether or not to use high precision timestamps
#
# @param imfiles
#   Specify imfile resources to create
#
class rsyslog::client (
  Boolean $log_remote = true,
  String[1] $spool_size = '1g',
  Optional[Integer[0]] $spool_timeoutenqueue = undef,
  Enum['tcp', 'udp', 'relp'] $remote_type = 'tcp',
  String[1] $remote_forward_format = 'RSYSLOG_ForwardFormat',
  Boolean $log_local = false,
  Boolean $disable_xconsole = false,
  Optional[Variant[Array[String[1]], String[1]]] $log_local_custom = undef,
  Boolean $log_auth_local = false,
  Boolean $listen_localhost = false,
  Boolean $split_config = false,
  Optional[String[1]] $custom_config = undef,
  Stdlib::Host $server = 'log',
  Variant[String[1], Stdlib::Port] $port = '514',
  Array[Hash] $remote_servers = [],
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
  Boolean $high_precision_timestamps = false,
  Hash $imfiles = {},
) inherits rsyslog::params {
  include rsyslog

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
