# @summary
#   Meta class to install rsyslog with a basic configuration.
#   You propably want rsyslog::client or rsyslog::server
#
# @example Puppet usage
#   class { 'rsyslog': }
#
# @param rsyslog_package_name
#   rsyslog package name
#
# @param relp_package_name
#   rsyslog relp package name
#
# @param mysql_package_name
#   rsyslog mysql package name
#
# @param pgsql_package_name
#   rsyslog postgresql package name
#
# @param gnutls_package_name
#   rsyslog gnutls package name
#
# @param package_status
#   Set ensure on package resources
#
# @param rsyslog_d
#   Path of directory containing configuration snippets
#
# @param purge_rsyslog_d
#   Whether or not unmanaged files in `rsyslog_d` dir should be removed
#
# @param rsyslog_conf
#   Path to rsyslog main configuration file
#
# @param rsyslog_conf_template_file
#   Name of the rsyslog.conf template file to use
#
# @param rsyslog_default
#   rsyslog default file path
#
# @param rsyslog_default_file
#   `rsyslog_d` file template to use
#
# @param run_user
#   Which user rsyslog should run as
#
# @param run_group
#   Which group rsyslog should run as
#
# @param log_user
#   Which user should be used for log files and directories
#
# @param log_group
#   Which group should be used for log files and directories
#
# @param log_style
#   Selects the local log style in use
#
# @param umask
#   The umask parameter allows to specify the rsyslogd processes’ umask
#
# @param perm_file
#   File mode to use when creating new files
#
# @param perm_dir
#   Sets the default dirCreateMode to be used for an action if no explicit one is specified.
#
# @param spool_dir
#   Sets the directory that rsyslog uses for work files, e.g. imfile state or queue spool files
#
# @param service_name
#   rsyslog service name
#
# @param service_hasrestart
#   Does the service has a restart option?
#
# @param service_hasstatus
#   Does the service has a status option?
#
# @param modules
#   rsyslog modules to load
#
# @param preserve_fqdn
#   Use full name of host even if sender and receiver are in the same domain
#
# @param local_host_name
#   Use a custom local host name, instead of clients actual host name
#
# @param max_message_size
#   Allows to specify maximum supported message size (both for sending and receiving)
#
# @param system_log_rate_limit_interval
#   Specifies the number of seconds per rate limit interval
#
# @param system_log_rate_limit_burst
#   Specifies the number of messages before limiting begins
#
# @param extra_modules
#   Extra rsyslog modules to load
#
# @param default_template_customisation
#   If set, this defines the `ActionFileDefaultTemplate custom formatting` which sets customisations over the default log format for remote and local logging. Must be used with actionfiletemplate to take effect
#
# @param default_template
#   If set, this defines the `ActionFileDefaultTemplate` which sets the default logging format for remote and local logging
#
# @param msg_reduction
#   Reduce repeated messages
#
# @param non_kernel_facility
#   Permit non-kernel facility messages in the kernel log
#
# @param omit_local_logging
#   Turn off message reception via local log socket
#
# @param im_journal_ratelimit_interval
#   Specifies the interval in seconds onto which rate-limiting is to be applied
#
# @param im_journal_statefile
#   This is a global setting. It specifies where the state file for persisting journal state is located
#
# @param im_journal_ratelimit_burst
#   Specifies the maximum number of messages that can be emitted within the ratelimit.interval interval
#
# @param im_journal_ignore_previous_messages
#   This option specifies whether imjournal should ignore messages currently in journal and read only new messages
#
# @param rsyslog_conf_mode
#   Force a specific mode on the main rsyslog.conf file
#
# @param rsyslog_d_mode
#   Force a specific mode on the rsyslog.d directory
#
# @param purge_ignore
#   Files to exclude from purging in rsyslog.d directory
#
# @param usrmsg_users
#   Array of user names that will receive emergency messages when logged
#
class rsyslog (
  Variant[Boolean[false], String[1]] $rsyslog_package_name = $rsyslog::params::rsyslog_package_name,
  Variant[Boolean[false], String[1]] $relp_package_name = $rsyslog::params::relp_package_name,
  Variant[Boolean[false], String[1]] $mysql_package_name = $rsyslog::params::mysql_package_name,
  Variant[Boolean[false], String[1]] $pgsql_package_name = $rsyslog::params::pgsql_package_name,
  Variant[Boolean[false], String[1]] $gnutls_package_name = $rsyslog::params::gnutls_package_name,
  String[1] $package_status = $rsyslog::params::package_status,
  Stdlib::Absolutepath $rsyslog_d = $rsyslog::params::rsyslog_d,
  Boolean $purge_rsyslog_d = $rsyslog::params::purge_rsyslog_d,
  Stdlib::Absolutepath $rsyslog_conf = $rsyslog::params::rsyslog_conf,
  String[1] $rsyslog_conf_template_file = "${module_name}/rsyslog.conf.erb",
  Stdlib::Absolutepath $rsyslog_default = $rsyslog::params::rsyslog_default,
  String[1] $rsyslog_default_file = $rsyslog::params::default_config_file,
  String[1] $run_user = $rsyslog::params::run_user,
  String[1] $run_group = $rsyslog::params::run_group,
  String[1] $log_user = $rsyslog::params::log_user,
  String[1] $log_group = $rsyslog::params::log_group,
  Enum['debian', 'freebsd', 'redhat'] $log_style = $rsyslog::params::log_style,
  Optional[Stdlib::Filemode] $umask = $rsyslog::params::umask,
  Stdlib::Filemode $perm_file = $rsyslog::params::perm_file,
  Stdlib::Filemode $perm_dir = $rsyslog::params::perm_dir,
  Stdlib::Absolutepath $spool_dir = $rsyslog::params::spool_dir,
  String[1] $service_name = $rsyslog::params::service_name,
  Boolean $service_hasrestart = $rsyslog::params::service_hasrestart,
  Boolean $service_hasstatus = $rsyslog::params::service_hasstatus,
  Array[String[1]] $modules = $rsyslog::params::modules,
  Boolean $preserve_fqdn = $rsyslog::params::preserve_fqdn,
  Optional[String[1]] $local_host_name = undef,
  String[1] $max_message_size = $rsyslog::params::max_message_size,
  Variant[String[1], Integer[0]] $system_log_rate_limit_interval = $rsyslog::params::system_log_rate_limit_interval,
  Variant[String[1], Integer[0]] $system_log_rate_limit_burst = $rsyslog::params::system_log_rate_limit_burst,
  Array $extra_modules = $rsyslog::params::extra_modules,
  Optional[String[1]] $default_template_customisation = $rsyslog::params::default_template_customisation,
  Optional[String[1]] $default_template = $rsyslog::params::default_template,
  Boolean $msg_reduction = $rsyslog::params::msg_reduction,
  Boolean $non_kernel_facility = $rsyslog::params::non_kernel_facility,
  Boolean $omit_local_logging = $rsyslog::params::omit_local_logging,
  Optional[Variant[String[1], Integer[0]]] $im_journal_ratelimit_interval = $rsyslog::params::im_journal_ratelimit_interval,
  Optional[Variant[Stdlib::Absolutepath, String[1]]] $im_journal_statefile = $rsyslog::params::im_journal_statefile,
  Optional[Variant[String[1], Integer[0]]] $im_journal_ratelimit_burst = $rsyslog::params::im_journal_ratelimit_burst,
  Optional[Enum['on', 'off']] $im_journal_ignore_previous_messages = $rsyslog::params::im_journal_ignore_previous_messages,
  Optional[Stdlib::Filemode] $rsyslog_conf_mode = undef,
  Optional[Stdlib::Filemode] $rsyslog_d_mode = undef,
  Optional[Variant[String[1], Array[String[1]]]] $purge_ignore = undef,
  Array[String[1]] $usrmsg_users = ['*'],
) inherits rsyslog::params {
  require rsyslog::install

  file { $rsyslog_d:
    ensure  => directory,
    owner   => 'root',
    group   => $run_group,
    mode    => $rsyslog_d_mode,
    purge   => $purge_rsyslog_d,
    ignore  => $purge_ignore,
    recurse => true,
    force   => true,
    notify  => Service[$service_name],
    require => Class['rsyslog::install'],
  }

  file { $rsyslog_conf:
    ensure  => file,
    owner   => 'root',
    group   => $run_group,
    mode    => $rsyslog_conf_mode,
    content => template($rsyslog_conf_template_file),
    notify  => Service[$service_name],
    require => File[$rsyslog_d],
  }

  file { $rsyslog_default:
    ensure  => file,
    owner   => 'root',
    group   => $run_group,
    content => template("${module_name}/${rsyslog_default_file}.erb"),
    notify  => Service[$service_name],
    require => File[$rsyslog_conf],
  }

  file { $spool_dir:
    ensure  => directory,
    owner   => $run_user,
    group   => $run_group,
    mode    => '0700',
    seltype => 'syslogd_var_lib_t',
    notify  => Service[$service_name],
    require => File[$rsyslog_default],
  }

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
    require    => File[$spool_dir],
  }
}
