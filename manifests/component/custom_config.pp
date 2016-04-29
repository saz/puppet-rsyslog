# This is a catch-all definition for use in edge cases where some code needs
# inserting somewhere in rsyslog.d according to priority but cannot be modelled
# with any of the shipped models.  
#
define rsyslog::component::custom_config (
  Integer $priority,
  String  $target,
  String  $content,
  String  $filename_part = $name,
) {

  include rsyslog

  concat::fragment { "rsyslog::component::custom_config::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    order   => $priority,
    content => $content,
  }
}
