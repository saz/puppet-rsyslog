class rsyslog::config::main_queue {
  unless empty($::rsyslog::config::main_queue_opts) {
    rsyslog::component::main_queue {
      default:
        priority => $::rsyslog::main_queue_priority,
        target   => $::rsyslog::target_file,
        confdir  => $::rsyslog::confdir,
      ;
      'main_queue_opts':
        config => $::rsyslog::config::main_queue_opts,
      ;
    }
  }
}

