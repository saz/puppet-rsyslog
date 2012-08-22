class rsyslog::params {
  case $::operatingsystem {
    ubuntu, debian: {
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = 'rsyslog-relp'
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/default/rsyslog'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'adm'
      $log_perm_file          = '0640'
      $log_perm_dir           = '0755'
      $spool_dir              = '/var/spool/rsyslog/'
      $service_name           = 'rsyslog'
      $client_conf            = "${rsyslog_d}client.conf"
      $server_conf            = "${rsyslog_d}server.conf"
    }
    freebsd: {
      $rsyslog_package_name   = 'rsyslog5'
      $relp_package_name      = 'rsyslog5-relp'
      $package_status         = 'present'
      $rsyslog_d              = '/etc/syslog.d/'
      $rsyslog_conf           = '/etc/syslog.conf'
      $rsyslog_default        = '/etc/defaults/syslogd'
      $run_user               = 'root'
      $run_group              = 'wheel'
      $log_user               = 'root'
      $log_group              = 'wheel'
      $log_perm_file          = '0640'
      $log_perm_dir           = '0755'
      $spool_dir              = '/var/spool/syslog/'
      $service_name           = 'syslogd'
      $client_conf            = "${rsyslog_d}client.conf"
      $server_conf            = "${rsyslog_d}server.conf"
    }
    redhat, centos, fedora: {
      $rsyslog_package_name   = 'rsyslog'
      $relp_package_name      = 'rsyslog-relp'
      $package_status         = 'latest'
      $rsyslog_d              = '/etc/rsyslog.d/'
      $rsyslog_conf           = '/etc/rsyslog.conf'
      $rsyslog_default        = '/etc/sysconfig/rsyslog'
      $run_user               = 'root'
      $run_group              = 'root'
      $log_user               = 'root'
      $log_group              = 'root'
      $log_perm_file          = '0640'
      $log_perm_dir           = '0755'
      $spool_dir              = '/var/spool/rsyslog/'
      $service_name           = 'rsyslog'
      $client_conf            = "${rsyslog_d}client.conf"
      $server_conf            = "${rsyslog_d}server.conf"
    }


    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

}
