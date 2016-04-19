class rsyslog::config::custom {

  $::rsyslog::config::custom_config.each |$conf_name, $config| {
    rsyslog::component::custom_config { $conf_name:
      *          => {
      'priority' => $rsyslog::custom_priority,
      'target'   => $rsyslog::target_file
      } + $config,
    }
  }
}
