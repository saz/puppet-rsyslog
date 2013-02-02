# == Class: rsyslog::install
#
# This class makes sure that the required packages are installed
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::install': }
#
class rsyslog::install inherits rsyslog::params {

  package { $rsyslog::params::rsyslog_package_name:
    ensure => $rsyslog::params::package_status,
  }

  package { $rsyslog::params::relp_package_name:
    ensure => $rsyslog::params::package_status
  }

}
