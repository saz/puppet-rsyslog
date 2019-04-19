# == Define: rsyslog::snippet
#
# This class allows for you to create a rsyslog configuration file with
# whatever content you pass in.
#
# === Parameters
#
# [*content*]   - The actual content to place in the file. (default: empty sting)
# [*ensure*]    - How to enforce the file (default: present)
# [*file_mode*] - The mode of the file snippet (default: $rsyslog::perm_file)
#
# === Variables
#
# === Examples
#
#  rsyslog::snippet { 'my-rsyslog-config':
#    content => '<Some rsyslog directive>',
#  }
#
define rsyslog::snippet(
  $content    = '',
  $ensure     = 'present',
  $file_mode  = 'undef'
) {
  include ::rsyslog

  if $file_mode == 'undef' {
    $file_mode_real = $rsyslog::perm_file
  } else {
    $file_mode_real = $file_mode
  }

  $name_real = regsubst($name,'[/ ]','-','G')
  file { "${rsyslog::rsyslog_d}${name_real}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => $rsyslog::run_group,
    mode    => $file_mode_real,
    content => "# This file is managed by Puppet, changes may be overwritten\n${content}\n",
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }

}
