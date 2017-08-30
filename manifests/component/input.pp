define rsyslog::component::input (
  Integer           $priority,
  String            $target,
  String            $confdir,
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

  rsyslog::generate_concat { "rsyslog::concat::input::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::input::${name}"],
  }

  concat::fragment {"rsyslog::component::input::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
