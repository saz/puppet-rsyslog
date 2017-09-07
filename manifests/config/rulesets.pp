class rsyslog::config::rulesets {
  $::rsyslog::config::rulesets.each |$ruleset, $config| {
    rsyslog::component::ruleset { $ruleset:
      * => {
        'priority' => $::rsyslog::ruleset_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config,
    }
  }
}