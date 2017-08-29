class rsyslog::config::actions {
  $::rsyslog::config::actions.each |$action, $config| {
    rsyslog::component::action { $action:
      * => {
        'priority' => $::rsyslog::action_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config,
    }
  }
}
