class rsyslog::client (
  Optional[Hash]  $global_config   = {},
  Optional[Hash]  $legacy_config   = {},
  Optional[Hash]  $actions         = {},
  Optional[Hash]  $inputs          = {},
  Optional[Hash]  $custom_config   = {},
  Optional[Hash]  $modules         = {},
  Optional[Hash]  $lookup_tables   = {},
) {

  include rsyslog

  class { 'rsyslog::config':
    global_config => $global_config,
    legacy_config => $legacy_config,
    actions       => $actions,
    inputs        => $inputs,
    custom_config => $custom_config,
    modules       => $modules,
    lookup_tables => $lookup_tables,
  }


}
