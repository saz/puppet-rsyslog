class rsyslog::config::lookup_tables {
  $::rsyslog::config::lookup_tables.each |$table, $config| {
    rsyslog::component::lookup_table { $table:
      * => {
        'priority' => $::rsyslog::lookup_table_priority,
        'target'   => $::rsyslog::target_file,
        'confdir'  => $::rsyslog::confdir,
      } + $config,
    }
  }
}