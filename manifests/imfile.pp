# == Define: rsyslog::imfile
#
# Full description of class role here.
#
# === Parameters
#
# [*file_name*]
# [*file_tag*]
# [*file_facility*]
# [*file_readmode*]
# [*ensure*]
# [*polling_interval*]
# [*file_severity*]
# [*run_file_monitor*]
# [*persist_state_interval]
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
  $file_readmode = undef,
  $ensure = 'present',
  $polling_interval = 10,
  $file_severity = 'notice',
  $run_file_monitor = true,
  $persist_state_interval = 0,
  $imfile_template = 'rsyslog/imfile.erb',
) {

  include ::rsyslog
  $extra_modules = $rsyslog::extra_modules

  # This mode should defined when having multiline messages.
  $imfile_readmode = $file_readmode ? {
    /^$/                 => undef, # Do not specify in configuration (current default behaviour)
    undef                => undef, # Do not specify in configuration (current default behaviour)
    /^(0|default|line)$/ => 0,     # Each line is a new message.
    /^(1|paragraph)$/    => 1,     # There is a blank line between log messages.
    /^(2|indented)$/     => 2,     # New log messages start at the beginning of a line. If a line starts with a space it is part of the log message before it.
    default              => fail("Invalid file_readmode '${file_readmode}'. The value can range from 0-2 and determines the multiline detection method."),
  }

  rsyslog::snippet { $name:
    ensure  => $ensure,
    content => template($imfile_template),
  }

}
