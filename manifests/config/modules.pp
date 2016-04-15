class rsyslog::config::modules {

  $modules = $rsyslog::modules
  concat::fragment { "rsyslog::config::modules":
    target  => "${rsyslog::confdir}/${rsyslog::target_file}",
    order   => $rsyslog::module_load_priority,
    content => epp('rsyslog/modules.epp',
      { 
        'modules' => $modules
      }
    ),
  }
}


