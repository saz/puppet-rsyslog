define rsyslog::component::input (
  Integer           $priority,
  String            $target,
  String            $type,
  Optional[Hash]    $config,
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/input.epp', {
        'input_name'  => $name,
        'type'        => $type,
        'config'      => $config
  })

  concat::fragment {"rsyslog::component::input::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
