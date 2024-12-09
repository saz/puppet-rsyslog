# == Class: rsyslog::config
#
# Full description of class role here.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::config': }
#
class rsyslog::config {

  File {
    owner   => 'root',
    group   => $rsyslog::run_group,
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

  file { $rsyslog::rsyslog_d:
    ensure  => directory,
    purge   => $rsyslog::purge_rsyslog_d,
    recurse => true,
    force   => true,
  }

  file { $rsyslog::rsyslog_conf:
    ensure  => file,
    content => template("${module_name}/rsyslog.conf.erb"),
  }

  if $rsyslog::rsyslog_default_file {
    file { $rsyslog::rsyslog_default:
      ensure  => file,
      owner   => 'root',
      group   => $rsyslog::run_group,
      content => template("${module_name}/${rsyslog::rsyslog_default_file}.erb"),
      require => Class['rsyslog::install'],
      notify  => Class['rsyslog::service'],
    }
  }

  file { $rsyslog::spool_dir:
    ensure  => directory,
    owner   => $rsyslog::run_user,
    mode    => '0700',
    seltype => 'syslogd_var_lib_t',
  }

}
