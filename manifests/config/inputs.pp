class rsyslog::config::inputs {
  $::rsyslog::config::inputs.each |$input, $config| {
    rsyslog::component::input { $input:
      *            => {
        'priority' => $rsyslog::input_priority,
        'target'   => $rsyslog::target_file,
      } + $config,
    }
  }
}
