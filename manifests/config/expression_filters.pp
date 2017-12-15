class rsyslog::config::expression_filters {
  $::rsyslog::config::expression_filters.each |$filter, $config| {
    rsyslog::component::expression_filter { $filter:
      * => {
        'priority' => $::rsyslog::filter_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config
    }
  }
}