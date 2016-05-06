define rsyslog::component::action (
  Integer           $priority,
  String            $target,
  String            $type,
  Optional[Hash]    $config,
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/action.epp', {
        'action_name' => $name,
        'type'        => $type,
        'config'      => $config,
  })

  concat::fragment {"rsyslog::component::action::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
