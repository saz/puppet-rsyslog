define rsyslog::component::expression_filter (
  Integer $priority,
  String $target,
  String $confdir,
  Hash $conditionals,
  Optional[String] $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/expression_filter.epp', {
    'filter_name'  => $name,
    'conditionals' => $conditionals,
  })

  rsyslog::generate_concat { "rsyslog::concat::expression_filter::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::expression_filter::${name}"],
  }

  concat::fragment { "rsyslog::component::expression_filter::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}