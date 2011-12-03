class rsyslog::params {
    case $::operatingsystem {
        /(Ubuntu|Debian)/: {
            $rsyslog_package_name = 'rsyslog'
            $relp_package_name = 'rsyslog-relp'
            $rsyslog_d = '/etc/rsyslog.d/'
            $rsyslog_conf = '/etc/rsyslog.conf'
            $rsyslog_default = '/etc/default/rsyslog'
            $spool_dir = '/var/spool/rsyslog/'
            $service_name = 'rsyslog'
            $client_conf = "${rsyslog_d}client.conf"
            $server_conf = "${rsyslog_d}server.conf"
        }
    }

    #
    # Internal variables
    #

    # Drop privileges to this user and group
    $run_user = 'root'
    $run_group = 'root'

    # User and group of log files
    $log_user = 'root'
    $log_group = 'adm'
}
