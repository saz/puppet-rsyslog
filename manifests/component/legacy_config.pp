define rsyslog::component::legacy_config (
  Integer           $priority,
  String            $target,
  String            $value,
  Optional[String]  $key,
  Optional[String]  $type = 'sysklogd',
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/legacy_config.epp', {
        'config_item' => $name,
        'type'        => $type,
        'key'         => $key,
        'value'       => $value,
  })

  concat::fragment {"rsyslog::component::legacy_config::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
