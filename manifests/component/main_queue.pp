define rsyslog::component::main_queue (
  Integer $priority,
  String  $target,
  String  $confdir,
  Hash    $config,
) {
  include rsyslog

  rsyslog::generate_concat { "rsyslog::concat::main_queue::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::main_queue::${name}"],
  }

  concat::fragment { "rsyslog::component::main_queue::${name}":
    order   => $priority,
    target  => "${confdir}/${target}",
    content => epp('rsyslog/generic.epp',
      {
        'object_name' => 'main_queue',
        'config'      => $config
      }),
  }
}