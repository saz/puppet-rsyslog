class rsyslog::config::property_filters {
  $::rsyslog::config::property_filters.each |$filter, $config| {
    rsyslog::component::property_filter { $filter:
      * => {
        'priority' => $::rsyslog::filter_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config
    }
  }
}