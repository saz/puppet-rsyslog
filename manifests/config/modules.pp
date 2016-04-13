class rsyslog::config::modules {

  $modules = $rsyslog::modules
  $module_priority = $rsyslog::module_load_priority

  file { "${rsyslog::confdir}/${module_priority}_modules.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => epp('rsyslog/modules.epp', { 'modules' => $modules }),
  }

}


