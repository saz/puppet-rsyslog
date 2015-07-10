# == Class: rsyslog::params
#
# This defines default configuration values for rsyslog.
# You don't want to use it directly.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::params': }
#
class rsyslog::params {

  $max_message_size           = '2k'
  $purge_rsyslog_d            = false
  $extra_modules              = []
  $default_template           = undef
  $msg_reduction              = false
  $non_kernel_facility        = false
  $preserve_fqdn              = false

  case $::osfamily {
    debian: {
      case $::operatingsystem {
        'Debian': {
          $log_user  = 'root'
          $run_user  = 'root'
          $run_group = 'root'
        }
        'Ubuntu': {
          $log_user  = 'syslog'
          $run_user  = 'syslog'
          $run_group = 'syslog'
        }
      }
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = 'rsyslog-relp'
      $mysql_package_name     = 'rsyslog-mysql'
      $pgsql_package_name     = 'rsyslog-pgsql'
      $gnutls_package_name    = 'rsyslog-gnutls'
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/default/rsyslog'
      $default_config_file    = 'rsyslog_default'
      $log_group              = 'adm'
      $log_style              = 'debian'
      $umask                  = false
      $perm_file              = '0640'
      $perm_dir               = '0755'
      $spool_dir              = '/var/spool/rsyslog'
      $service_name           = 'rsyslog'
      $client_conf            = 'client'
      $server_conf            = 'server'
      $ssl                    = false
      $modules                = [
        '$ModLoad imuxsock # provides support for local system logging',
        '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
        '#$ModLoad immark  # provides --MARK-- message capability',
      ]
      $service_hasrestart     = true
      $service_hasstatus      = true
      $omit_local_logging     = false
    }
    redhat: {
      if $::operatingsystem == 'Amazon' {
        $rsyslog_package_name   = 'rsyslog'
        $mysql_package_name     = 'rsyslog-mysql'
        $pgsql_package_name     = 'rsyslog-pgsql'
        $gnutls_package_name    = 'rsyslog-gnutls'
        $relp_package_name      = false
        $default_config_file    = 'rsyslog_default'
        $modules                = [
          '$ModLoad imuxsock # provides support for local system logging',
          '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
          '#$ModLoad immark  # provides --MARK-- message capability',
        ]
        $omit_local_logging     = false
      }
      elsif versioncmp($::operatingsystemmajrelease, '5') == 0 {
        $rsyslog_package_name   = 'rsyslog'
        $mysql_package_name     = 'rsyslog-mysql'
        $pgsql_package_name     = 'rsyslog-pgsql'
        $gnutls_package_name    = 'rsyslog-gnutls'
        $relp_package_name      = 'rsyslog-relp'
        $default_config_file    = 'rsyslog_default'
        $modules                = [
          '$ModLoad imuxsock # provides support for local system logging',
          '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
          '#$ModLoad immark  # provides --MARK-- message capability',
        ]
        $omit_local_logging     = false
      }
      elsif versioncmp($::operatingsystemmajrelease, '6') == 0 {
        $rsyslog_package_name   = 'rsyslog'
        $mysql_package_name     = 'rsyslog-mysql'
        $pgsql_package_name     = 'rsyslog-pgsql'
        $gnutls_package_name    = 'rsyslog-gnutls'
        $relp_package_name      = 'rsyslog-relp'
        $default_config_file    = 'rsyslog_default'
        $modules                = [
          '$ModLoad imuxsock # provides support for local system logging',
          '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
          '#$ModLoad immark  # provides --MARK-- message capability',
        ]
        $omit_local_logging     = false
      }
      elsif versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $rsyslog_package_name   = 'rsyslog'
        $mysql_package_name     = 'rsyslog-mysql'
        $pgsql_package_name     = 'rsyslog-pgsql'
        $gnutls_package_name    = 'rsyslog-gnutls'
        $relp_package_name      = 'rsyslog-relp'
        $default_config_file    = 'rsyslog_default_rhel7'
        $modules                = [
          '$ModLoad imuxsock # provides support for local system logging',
          '$ModLoad imjournal # provides access to the systemd journal',
          '#$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
          '#$ModLoad immark  # provides --MARK-- message capability',
        ]
        $omit_local_logging     = true
      } else {
        $rsyslog_package_name   = 'rsyslog5'
        $mysql_package_name     = 'rsyslog5-mysql'
        $pgsql_package_name     = 'rsyslog5-pgsql'
        $gnutls_package_name    = 'rsyslog5-gnutls'
        $relp_package_name      = 'librelp'
        $default_config_file    = 'rsyslog_default'
        $modules                = [
          '$ModLoad imuxsock # provides support for local system logging',
          '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
          '#$ModLoad immark  # provides --MARK-- message capability',
        ]
        $omit_local_logging     = false
      }
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/sysconfig/rsyslog'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'root'
      $log_style              = 'redhat'
      $umask                  = '0000'
      $perm_file              = '0600'
      $perm_dir               = '0750'
      $spool_dir              = '/var/lib/rsyslog'
      $service_name           = 'rsyslog'
      $client_conf            = 'client'
      $server_conf            = 'server'
      $ssl                    = false
      $service_hasrestart     = true
      $service_hasstatus      = true
    }
    suse: {
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = false
      $mysql_package_name     = false
      $pgsql_package_name     = false
      $gnutls_package_name    = false
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/sysconfig/syslog'
      $default_config_file    = 'rsyslog_default'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'root'
      $log_style              = 'debian'
      $umask                  = false
      $perm_file              = '0600'
      $perm_dir               = '0750'
      $spool_dir              = '/var/spool/rsyslog/'
      $service_name           = 'syslog'
      $client_conf            = 'client'
      $server_conf            = 'server'
      $modules                = [
        '$ModLoad imuxsock # provides support for local system logging',
        '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
        '#$ModLoad immark  # provides --MARK-- message capability',
      ]
      $omit_local_logging     = false
    }
    freebsd: {
      $rsyslog_package_name   = 'sysutils/rsyslog5'
      $relp_package_name      = 'sysutils/rsyslog5-relp'
      $mysql_package_name     = 'sysutils/rsyslog5-mysql'
      $pgsql_package_name     = 'sysutils/rsyslog5-pgsql'
      $gnutls_package_name    = 'sysutils/rsyslog5-gnutls'
      $package_status         = 'present'
      $rsyslog_d              = '/etc/syslog.d/'
      $rsyslog_conf           = '/etc/syslog.conf'
      $rsyslog_default        = '/etc/defaults/syslogd'
      $default_config_file    = 'rsyslog_default'
      $run_user               = 'root'
      $run_group              = 'wheel'
      $log_user               = 'root'
      $log_group              = 'wheel'
      $log_style              = 'debian'
      $umask                  = false
      $perm_file              = '0640'
      $perm_dir               = '0755'
      $spool_dir              = '/var/spool/syslog'
      $service_name           = 'syslogd'
      $client_conf            = 'client'
      $server_conf            = 'server'
      $ssl                    = false
      $modules                = [
        '$ModLoad imuxsock # provides support for local system logging',
        '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
        '#$ModLoad immark  # provides --MARK-- message capability',
      ]
      $service_hasrestart     = true
      $service_hasstatus      = true
      $omit_local_logging     = false
    }
    default: {
      case $::operatingsystem {
        gentoo: {
          $rsyslog_package_name   = 'app-admin/rsyslog'
          $relp_package_name      = false
          $mysql_package_name     = 'rsyslog-mysql'
          $pgsql_package_name     = 'rsyslog-pgsql'
          $gnutls_package_name    = false
          $package_status         = 'latest'
          $rsyslog_d              = '/etc/rsyslog.d/'
          $rsyslog_conf           = '/etc/rsyslog.conf'
          $rsyslog_default        = '/etc/conf.d/rsyslog'
          $default_config_file    = 'rsyslog_default_gentoo'
          $run_user               = 'root'
          $run_group              = 'root'
          $log_user               = 'root'
          $log_group              = 'adm'
          $log_style              = 'debian'
          $umask                  = false
          $perm_file              = '0640'
          $perm_dir               = '0755'
          $spool_dir              = '/var/spool/rsyslog'
          $service_name           = 'rsyslog'
          $client_conf            = 'client'
          $server_conf            = 'server'
          $ssl                    = false
          $modules                = [
            '$ModLoad imuxsock # provides support for local system logging',
            '$ModLoad imklog   # provides kernel logging support (previously done by rklogd)',
            '#$ModLoad immark  # provides --MARK-- message capability',
          ]
          $service_hasrestart     = true
          $service_hasstatus      = true
          $omit_local_logging     = false
        }
        default: {
          fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}.")
        }
      }
    }
  }
}
