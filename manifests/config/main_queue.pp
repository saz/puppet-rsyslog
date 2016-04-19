class rsyslog::config::main_queue {

  unless empty($rsyslog::config::main_queue_opts) { 
    concat::fragment { "rsyslog::config::main_queue":
      order   => $rsyslog::main_queue_priority,
      target  => "${rsyslog::confdir}/${rsyslog::target_file}",
      content => epp('rsyslog/generic.epp',
      {
        'object_name' => 'main_queue',
        'config'      => $rsyslog::config::main_queue_opts
      }),
    }
  }
}

