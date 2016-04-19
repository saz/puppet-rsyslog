class rsyslog::config (
  Optional[Hash] $global_config = {},
  Optional[Hash] $templates = {},
  Optional[Hash] $actions = {},
  Optional[Hash] $inputs = {},
  Optional[Hash] $custom_config = {},
  Optional[Hash] $main_queue_opts = {},
  Optional[Array] $modules = [],
) {

  concat { "${::rsyslog::confdir}/${::rsyslog::target_file}":
    owner => 'root',
  }

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::main_queue
  include rsyslog::config::templates
  include rsyslog::config::actions
  include rsyslog::config::inputs
  include rsyslog::config::custom


}

