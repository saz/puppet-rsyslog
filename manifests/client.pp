class rsyslog::client (
  Optional[Hash]  $global_config   = {},
  Optional[Hash]  $actions         = {},
  Optional[Hash]  $inputs          = {},
  Optional[Hash]  $custom_config   = {},
  Optional[Array] $modules         = [],
) {

  include rsyslog

  class { 'rsyslog::config':
    global_config => $global_config,
    actions       => $actions,
    inputs        => $inputs,
    custom_config => $custom_config,
    modules       => $modules,
  }


}
