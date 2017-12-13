define rsyslog::component::property_filter (
  Integer $priority,
  String $target,
  String $confdir,
  String $property,
  Enum[ 'contains', 'isequal', 'startswith', 'regex', 'ereregex'] $operator,
  String $value,
  Optional[Hash] $tasks = {},
  Optional[String] $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/property_filter.epp', {
    'property' => $property,
    'operator' => $operator,
    'value'    => $value,
    'tasks'    => $tasks,
  })

  rsyslog::generate_concat { "rsyslog::concat::property_filter::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::property_filter::${name}"],
  }

  concat::fragment {"rsyslog::component::property_filter::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}