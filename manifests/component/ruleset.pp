define rsyslog::component::ruleset (
  Integer           $priority,
  String            $target,
  String            $confdir,
  Optional[Array]   $rules = [],
  Optional[Boolean] $stop = false,
  Optional[Hash]    $parameters = {},
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  if $rules == [] and $stop == false {
    fail('Ruleset MUST have at least one of: action, stop, set, call, or lookup')
  }

  $content = epp('rsyslog/ruleset.epp', {
    'ruleset_name' => $name,
    'parameters'   => $parameters,
    'rules'        => $rules,
    'stop'         => $stop,
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