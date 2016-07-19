class rsyslog::config::modules{
  $::rsyslog::config::modules.each|$name, $config| {
    rsyslog::component::module { $name:
      * => {
        'priority' => $::rsyslog::module_load_priority,
        'target'   => $::rsyslog::target_file,
      } + $config,
    }
  }
}
