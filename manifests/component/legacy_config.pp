define rsyslog::component::legacy_config (
  Integer           $priority,
  String            $target,
  String            $confdir,
  String            $value,
  Optional[String]  $key = 'legacy_key',
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

  rsyslog::generate_concat { "rsyslog::concat::legacy_config::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::legacy_config::${name}"],
  }

  concat::fragment {"rsyslog::component::legacy_config::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
