define rsyslog::component::lookup_table (
  Integer          $priority,
  String           $target,
  String           $confdir,
  Hash             $lookup_json,
  String           $lookup_file,
  Boolean          $reload_on_hup,
  Optional[String] $format = '<%= $content %>'
) {

  include rsyslog

  file { "rsyslog::component::lookup_table_json::${title}":
    path    => $lookup_file,
    content => inline_template('<%= JSON.pretty_generate @lookup_json %>'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  $content = epp('rsyslog/lookup_table.epp', {
        'lookup_table_name' => $name,
        'file'              => $lookup_file,
        'reload_on_hup'     => $reload_on_hup,
  })

  rsyslog::generate_concat { "rsyslog::concat::lookup_table::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::lookup_table::${name}"],
  }

  concat::fragment {"rsyslog::component::lookup_table::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
    require => File["rsyslog::component::lookup_table_json::${title}"],
  }
}