# @summary
#   This class manages rsyslog file imports
#
# @example Puppet usage
#   rsyslog::imfile { 'my-imfile':
#     file_name     => '/some/file',
#     file_tag      => 'mytag',
#     file_facility => 'local0',
#   }
#
# @param file_name
#   The file being monitored.
#
# @param file_tag
#   The tag to be assigned to messages read from this file.
#
# @param file_facility
#   The syslog facility to be assigned to messages read from this file.
#
# @param file_readmode
#   This provides support for processing some standard types of multiline messages.
#
# @param ensure
#   Set ensure on resource
#
# @param polling_interval
#   This setting specifies how often files are to be polled for new data.
#
# @param file_severity
#   The syslog severity to be assigned to lines read.
#
# @param persist_state_interval
#   Specifies how often the state file shall be written when processing the input file.
#
# @param imfile_template
#   Config file template to use.
#
define rsyslog::imfile (
  Stdlib::Absolutepath $file_name,
  String[1] $file_tag,
  Stdlib::Syslogfacility $file_facility,
  Optional[Integer[0,2]] $file_readmode = undef,
  Enum['present', 'absent'] $ensure = 'present',
  Integer[0] $polling_interval = 10,
  Variant[Integer[0,23], String[1]] $file_severity = 'notice',
  Integer[0] $persist_state_interval = 0,
  String[1] $imfile_template = 'rsyslog/imfile.erb',
) {
  include rsyslog
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
