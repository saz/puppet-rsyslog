define rsyslog::component::action (
  Integer           $priority,
  String            $type,
  Optional[Hash]    $config,
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  if $name =~ /\s/ {
    fail("Invalid action name ${name}, must not contain whitespace characters")
  }

  $content = epp('rsyslog/action.epp', {
        "action_name" => $name,
        "type"        => $type,
        "config"      => $config,
  })

  concat::fragment { "${::rsyslog::confdir}/${priority}_${name}_action.conf":
    target  => "/etc/rsyslog.d/00_actions",
    content => inline_epp($format)
  }

}
