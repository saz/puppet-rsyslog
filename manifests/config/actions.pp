class rsyslog::config::actions {
  $::rsyslog::actions.each |$action, $config| {
    rsyslog::component::action { $action:
      *            => {
        'priority' => $rsyslog::action_priority,
        'target'   => $rsyslog::target_file,
      } + $config,
    }
  }
}
