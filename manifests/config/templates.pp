class rsyslog::config::templates {

  $::rsyslog::templates.each |$template, $config| {
    rsyslog::component::template { $template:
      * => { 'priority' =>  $rsyslog::template_priority } + $config,
    }
  }
}
