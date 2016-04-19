class rsyslog::server (
  Optional[Hash] $global_config = {},
  Optional[Hash] $templates = {},
  Optional[Hash] $actions = {},
  Optional[Hash] $inputs = {},
  Optional[Hash] $custom_config = {},
  Optional[Hash] $main_queue_opts = {},
  Optional[Array] $modules = [],
) {

  include rsyslog


  class { 'rsyslog::config':
    global_config   => $global_config,
    templates       => $templates,
    actions         => $actions,
    inputs          => $inputs,
    custom_config   => $custom_config,
    main_queue_opts => $main_queue_opts,
    modules         => $modules,
  }



}
