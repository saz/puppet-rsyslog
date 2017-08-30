# This is a catch-all definition for use in edge cases where some code needs
# inserting somewhere in rsyslog.d according to priority but cannot be modelled
# with any of the shipped models.  
#
define rsyslog::component::custom_config (
  Integer $priority,
  String  $target,
  String  $confdir,
  String  $content,
  String  $filename_part = $name,
) {

  include rsyslog

  rsyslog::generate_concat { "rsyslog::concat::custom_config::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::custom_config::${name}"],
  }

  concat::fragment { "rsyslog::component::custom_config::${name}":
    target  => "${confdir}/${target}",
    order   => $priority,
    content => $content,
  }
}
