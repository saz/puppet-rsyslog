class rsyslog::config::parsers {
  $::rsyslog::config::parsers.each |$parser, $config| {
    rsyslog::component::parser { $parser:
      * => {
        'priority' => $::rsyslog::parser_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config,
    }
  }
}