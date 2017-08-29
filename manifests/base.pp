# Class: rsyslog::base
#
# Description
# -----------
#
# This class manages the base installation for rsyslog
class rsyslog::base {

  # Include the base class in case this class is being called
  # directly

  if $::rsyslog::manage_package {
    package { $::rsyslog::package_name:
      ensure => $::rsyslog::package_version,
    }
  }

  if $::rsyslog::feature_packages {
    package { $::rsyslog::feature_packages:
      ensure  => installed,
      require => Package[$::rsyslog::package_name],
    }
  }

  if $::rsyslog::manage_confdir {

    $purge_params = $::rsyslog::purge_config_files ? {
      true  => {
        'purge'   => true,
        'recurse' => true,
      },
      false => {}
    }

    file { $::rsyslog::confdir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      *       => $purge_params,
      require => Package[$::rsyslog::package_name],
    }
  }

  if $::rsyslog::override_default_config {

    $message = @(EOT)
      # This file is managed by Puppet.  No configuration is placed here
      # all configuration is under the rsyslog.d directory
      |EOT

    file { $::rsyslog::config_file:
      ensure  => 'file',
      content => "${message}\n\$IncludeConfig ${::rsyslog::confdir}/*.conf"
    }
  }

  if $::rsyslog::manage_service {
    service { $::rsyslog::service_name:
      ensure => $::rsyslog::service_status,
      enable => $::rsyslog::service_enabled,
    }
  }

}
