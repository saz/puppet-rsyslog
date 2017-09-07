define rsyslog::component::parser (
  Integer           $priority,
  String            $target,
  String            $confdir,
  String            $type,
  Optional[Hash]    $config,
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/parser.epp', {
        'parser_name' => $name,
        'type'        => $type,
        'config'      => $config
  })

  rsyslog::generate_concat { "rsyslog::concat::parser::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::parser::${name}"],
  }

  concat::fragment { "rsyslog::component::parser::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}