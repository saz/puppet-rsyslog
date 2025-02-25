# @summary
#   Manage rsyslog configuration snippets
#
# @example Puppet usage
#   rsyslog::snippet { 'my-rsyslog-config':
#     content => '<Some rsyslog directive>',
#   }
#
# @param content
#   The actual content to place in the file
#
# @param ensure
#   Set ensure for the resource
#
# @param file_mode
#   The mode of the file snippet
#
define rsyslog::snippet (
  Enum['present', 'file', 'absent'] $ensure = 'present',
  Optional[String[1]] $content = undef,
  Optional[String[1]] $source = undef,
  Optional[Stdlib::Filemode] $file_mode = undef,
) {
  if $content and $source {
    fail("rsyslog::snippet[${title}]: Can't set 'content' and 'source' at the same time")
  }

  if $file_mode {
    $file_mode_real = $file_mode
  } else {
    $file_mode_real = $rsyslog::perm_file
  }

  if $content {
    $content_real = "# This file is managed by Puppet, changes may be overwritten\n${content}\n"
  } else {
    $content_real = undef
  }

  $name_real = regsubst($name,'[/ ]','-','G')
  file { "${rsyslog::rsyslog_d}/${name_real}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => $rsyslog::run_group,
    mode    => $file_mode_real,
    content => $content_real,
    source  => $source,
    notify  => Service[$rsyslog::service_name],
    require => File[$rsyslog::rsyslog_d],
  }
}
