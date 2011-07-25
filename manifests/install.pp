class rsyslog::install {
    package { $rsyslog::params::rsyslog_package_name:
        ensure => latest,
    }

    package { $rsyslog::params::relp_package_name:
        ensure => latest,
    }
}
