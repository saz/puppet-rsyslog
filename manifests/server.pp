class rsyslog::server (
  Optional[Hash] $global_config      = {},
  Optional[Hash] $legacy_config      = {},
  Optional[Hash] $templates          = {},
  Optional[Hash] $actions            = {},
  Optional[Hash] $inputs             = {},
  Optional[Hash] $custom_config      = {},
  Optional[Hash] $main_queue_opts    = {},
  Optional[Hash] $modules            = {},
  Optional[Hash] $lookup_tables      = {},
  Optional[Hash] $parsers            = {},
  Optional[Hash] $rulesets           = {},
  Optional[Hash] $property_filters   = {},
  Optional[Hash] $expression_filters = {},
) {

  include rsyslog


  class { 'rsyslog::config':
    global_config      => $global_config,
    legacy_config      => $legacy_config,
    templates          => $templates,
    actions            => $actions,
    inputs             => $inputs,
    custom_config      => $custom_config,
    main_queue_opts    => $main_queue_opts,
    modules            => $modules,
    lookup_tables      => $lookup_tables,
    parsers            => $parsers,
    rulesets           => $rulesets,
    property_filters   => $property_filters,
    expression_filters => $expression_filters,
  }



}
