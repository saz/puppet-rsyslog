define rsyslog::component::module (
  Integer           $priority,
  String            $target,
  Optional[Hash]    $config = {},
  Optional[String]  $type = 'external',
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/modules.epp', {
        'config_item' => $name,
        'type'        => $type,
        'config'      => $config,
  })

  concat::fragment {"rsyslog::component::module::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}

