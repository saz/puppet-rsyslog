class rsyslog::config {

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::templates


}

