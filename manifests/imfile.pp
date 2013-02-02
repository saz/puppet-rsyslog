# == Define: rsyslog::imfile
#
# Full description of class role here.
#
# === Parameters
#
# [*file_name*]
# [*file_tag*]
# [*file_facility*]
# [*polling_interval*]
# [*file_severity*]
# [*run_file_monitor*]
#
# === Variables
#
# === Examples
#
#  rsyslog::imfile { 'my-imfile':
#    file_name     => '/some/file',
#    file_tag      => 'mytag',
#    file_facility => 'myfacility',
#  }
#
define rsyslog::imfile(
  $file_name,
  $file_tag,
  $file_facility,
  $polling_interval = 10,
  $file_severity = 'notice',
  $run_file_monitor = true
) {

  include rsyslog::params

  file { "${rsyslog::params::rsyslog_d}${name}.conf":
    ensure  => file,
    owner   => 'root',
    group   => $rsyslog::params::run_group,
    content => template('rsyslog/imfile.erb'),
    require => Class['rsyslog::install'],
    notify  => Class['rsyslog::service'],
  }

}
