class rsyslog::config::global {

  $rsyslog::global_config.each |$param, $config| {
    rsyslog::component::global_config { $param:
      *            => {
        'priority' => $rsyslog::global_config_priority,
        'target'   => $rsyslog::target_file,
      } + $config,
    }
  }
}

