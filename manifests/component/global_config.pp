define rsyslog::component::global_config (
  Integer           $priority,
  String            $target,
  String            $value,
  Optional[String]  $type = 'rainerscript',
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/global_config.epp', {
        'config_item' => $name,
        'type'        => $type,
        'value'       => $value
  })

  concat::fragment {"rsyslog::component::global_config::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
