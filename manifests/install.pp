# @summary
#   Manages rsyslog packages
#
# @api private
#
class rsyslog::install {
  assert_private()

  if $rsyslog::rsyslog_package_name != false {
    package { $rsyslog::rsyslog_package_name:
      ensure => $rsyslog::package_status,
      notify => Class['rsyslog::service'],
    }
  }

  if $rsyslog::relp_package_name != false {
    package { $rsyslog::relp_package_name:
      ensure => $rsyslog::package_status,
      notify => Class['rsyslog::service'],
    }
  }

  if $rsyslog::gnutls_package_name != false {
    package { $rsyslog::gnutls_package_name:
      ensure => $rsyslog::package_status,
      notify => Class['rsyslog::service'],
    }
  }
}
