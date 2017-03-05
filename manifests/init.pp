# == Class: rsyslog
#
# Meta class to install rsyslog with a basic configuration.
# You probably want rsyslog::client or rsyslog::server
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog': }
#
class rsyslog (
  $rsyslog_package_name                = $rsyslog::params::rsyslog_package_name,
  $relp_package_name                   = $rsyslog::params::relp_package_name,
  $mysql_package_name                  = $rsyslog::params::mysql_package_name,
  $pgsql_package_name                  = $rsyslog::params::pgsql_package_name,
  $gnutls_package_name                 = $rsyslog::params::gnutls_package_name,
  $package_status                      = $rsyslog::params::package_status,
  $rsyslog_d                           = $rsyslog::params::rsyslog_d,
  $purge_rsyslog_d                     = $rsyslog::params::purge_rsyslog_d,
  $rsyslog_conf                        = $rsyslog::params::rsyslog_conf,
  $rsyslog_default                     = $rsyslog::params::rsyslog_default,
  $rsyslog_default_file                = $rsyslog::params::default_config_file,
  $run_user                            = $rsyslog::params::run_user,
  $run_group                           = $rsyslog::params::run_group,
  $log_user                            = $rsyslog::params::log_user,
  $log_group                           = $rsyslog::params::log_group,
  $log_style                           = $rsyslog::params::log_style,
  $umask                               = $rsyslog::params::umask,
  $perm_file                           = $rsyslog::params::perm_file,
  $perm_dir                            = $rsyslog::params::perm_dir,
  $spool_dir                           = $rsyslog::params::spool_dir,
  $service_name                        = $rsyslog::params::service_name,
  $service_hasrestart                  = $rsyslog::params::service_hasrestart,
  $service_hasstatus                   = $rsyslog::params::service_hasstatus,
  $modules                             = $rsyslog::params::modules,
  $preserve_fqdn                       = $rsyslog::params::preserve_fqdn,
  $local_host_name                     = undef,
  $max_message_size                    = $rsyslog::params::max_message_size,
  $system_log_rate_limit_interval      = $rsyslog::params::system_log_rate_limit_interval,
  $system_log_rate_limit_burst         = $rsyslog::params::system_log_rate_limit_burst,
  $extra_modules                       = $rsyslog::params::extra_modules,
  $default_template_customisation      = $rsyslog::params::default_template_customisation,
  $default_template                    = $rsyslog::params::default_template,
  $msg_reduction                       = $rsyslog::params::msg_reduction,
  $non_kernel_facility                 = $rsyslog::params::non_kernel_facility,
  $omit_local_logging                  = $rsyslog::params::omit_local_logging,
  $im_journal_ratelimit_interval       = $rsyslog::params::im_journal_ratelimit_interval,
  $im_journal_statefile                = $rsyslog::params::im_journal_statefile,
  $im_journal_ratelimit_burst          = $rsyslog::params::im_journal_ratelimit_burst,
  $im_journal_ignore_previous_messages = $rsyslog::params::im_journal_ignore_previous_messages
) inherits rsyslog::params {

  contain rsyslog::install
  contain rsyslog::config
  contain rsyslog::service

  if $extra_modules != [] {
    include rsyslog::modload
  }

  Class['rsyslog::install'] -> Class['rsyslog::config'] ~> Class['rsyslog::service']

}

