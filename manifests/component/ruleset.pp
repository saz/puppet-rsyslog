define rsyslog::component::ruleset (
  Integer           $priority,
  String            $target,
  String            $confdir,
  Array             $rules,
  Optional[Hash]    $parameters = {},
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/ruleset.epp', {
    'ruleset_name' => $name,
    'parameters'   => $parameters,
    'rules'        => $rules,
  })

  rsyslog::generate_concat { "rsyslog::concat::ruleset::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::ruleset::${name}"],
  }

  concat::fragment { "rsyslog::component::ruleset::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}