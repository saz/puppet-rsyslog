class rsyslog::config (
  Optional[Hash] $global_config = {},
  Optional[Hash] $legacy_config = {},
  Optional[Hash] $templates = {},
  Optional[Hash] $actions = {},
  Optional[Hash] $inputs = {},
  Optional[Hash] $custom_config = {},
  Optional[Hash] $main_queue_opts = {},
  Optional[Hash] $modules = {},
  Optional[Hash] $lookup_tables = {},
  Optional[Hash] $parsers = {},
  Optional[Hash] $rulesets = {},
  Hash $property_filters = {},
  Hash $expression_filters = {},
) {

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::legacy
  include rsyslog::config::main_queue
  include rsyslog::config::templates
  include rsyslog::config::actions
  include rsyslog::config::inputs
  include rsyslog::config::custom
  include rsyslog::config::lookup_tables
  include rsyslog::config::parsers
  include rsyslog::config::rulesets
  include rsyslog::config::property_filters
  include rsyslog::config::expression_filters

}

