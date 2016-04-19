class rsyslog::config {

  concat { "${::rsyslog::confdir}/${::rsyslog::target_file}":
    owner  => 'root',
    notify => Service[$::rsyslog::service_name],
  }

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::main_queue
  include rsyslog::config::templates
  include rsyslog::config::actions
  include rsyslog::config::inputs
  include rsyslog::config::custom


}

