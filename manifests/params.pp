# == Class: rsyslog::params
#
# This defines default configuration values for rsyslog.  You don't want to use it directly.
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

  case $::osfamily {
    debian: {
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = 'rsyslog-relp'
      $mysql_package_name     = 'rsyslog-mysql'
      $pgsql_package_name     = 'rsyslog-pgsql'
      $gnutls_package_name    = 'rsyslog-gnutls'
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $purge_rsyslog_d        = false
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/default/rsyslog'
      $default_config_file    = 'rsyslog_default'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'adm'
      $log_style              = 'debian'
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
      $preserve_fqdn          = false
      $service_hasrestart     = true
      $service_hasstatus      = true
      $extra_modules          = []

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
      }
      elsif $::operatingsystemmajrelease == 6 {
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
      }
      elsif $::operatingsystemmajrelease >= 7 {
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
      }
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $purge_rsyslog_d        = false
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/sysconfig/rsyslog'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'root'
      $log_style              = 'redhat'
      $perm_file              = '0600'
      $perm_dir               = '0750'
      $spool_dir              = '/var/lib/rsyslog'
      $service_name           = 'rsyslog'
      $client_conf            = 'client'
      $server_conf            = 'server'
      $ssl                    = false
      $preserve_fqdn          = false
      $service_hasrestart     = true
      $service_hasstatus      = true
      $extra_modules          = []

    }
    sles: {
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = 'rsyslog-module-relp'
      $mysql_package_name     = 'rsyslog-module-mysql'
      $pgsql_package_name     = 'rsyslog-module-pgsql'
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/sysconfig/syslog'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'root'
      $log_style              = 'sles'
      $perm_file              = '0600'
      $perm_dir               = '0750'
      $spool_dir              = '/var/spool/rsyslog/'
      $service_name           = 'syslog'
      $client_conf            = "${rsyslog_d}client.conf"
      $server_conf            = "${rsyslog_d}server.conf"
      $extra_modules          = []
    }
    freebsd: {
      $rsyslog_package_name   = 'sysutils/rsyslog5'
      $relp_package_name      = 'sysutils/rsyslog5-relp'
      $mysql_package_name     = 'sysutils/rsyslog5-mysql'
      $pgsql_package_name     = 'sysutils/rsyslog5-pgsql'
      $gnutls_package_name    = 'sysutils/rsyslog5-gnutls'
      $package_status         = 'present'
      $rsyslog_d              = '/etc/syslog.d/'
      $purge_rsyslog_d        = false
      $rsyslog_conf           = '/etc/syslog.conf'
      $rsyslog_default        = '/etc/defaults/syslogd'
      $default_config_file    = 'rsyslog_default'
      $run_user               = 'root'
      $run_group              = 'wheel'
      $log_user               = 'root'
      $log_group              = 'wheel'
      $log_style              = 'debian'
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
      $preserve_fqdn          = false
      $service_hasrestart     = true
      $service_hasstatus      = true
      $extra_modules          = []
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
          $purge_rsyslog_d        = false
          $rsyslog_conf           = '/etc/rsyslog.conf'
          $rsyslog_default        = '/etc/conf.d/rsyslog'
          $default_config_file    = 'rsyslog_default_gentoo'
          $run_user               = 'root'
          $run_group              = 'root'
          $log_user               = 'root'
          $log_group              = 'adm'
          $log_style              = 'debian'
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
          $preserve_fqdn          = false
          $service_hasrestart     = true
          $service_hasstatus      = true
          $extra_modules          = []
        }
        default: {
          fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}.")
        }
      }
    }
  }
}
