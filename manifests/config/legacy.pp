class rsyslog::config::legacy {
  $::rsyslog::config::legacy_config.each |$name, $config| {
    rsyslog::component::legacy_config { $name:
      * => {
        'priority' => $::rsyslog::legacy_config_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config,
    }
  }
}
