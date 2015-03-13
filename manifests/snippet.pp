# == Define: rsyslog::snippet
#
# This class allows for you to create a rsyslog configuration file with
# whatever content you pass in.
#
# === Parameters
#
# [*content*] - The actual content to place in the file.
# [*ensure*]  - How to enforce the file (default: present)
# [*file_owner*] - The owner of the file snippet (default: root)
# [*file_group*] - The group of the file snippet (default: $rsyslog::run_group)
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
  $content,
  $ensure     = 'present',
  $file_owner = 'root',
  $file_group = $rsyslog::run_group,
  $file_mode  = $rsyslog::perm_file
) {

  include rsyslog

  file { "${rsyslog::rsyslog_d}${name}.conf":
    ensure  => $ensure,
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    content => "# This file is managed by Puppet, changes may be overwritten\n${content}\n",
    require => Class['rsyslog::config'],
    notify  => Class['rsyslog::service'],
  }

}
