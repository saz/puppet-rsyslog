class rsyslog::config::global {
  #create a hash just with legacy type values
  $legacytype = $::rsyslog::config::global_config.filter |$key, $value| { has_key( $value, 'type')}

  $legacytype.each |$param, $config| {
    rsyslog::component::global_config { $param:
      * => {
        'priority' => $::rsyslog::global_config_priority,
        'target'   => $::rsyslog::target_file,
      } + $config,
    }
  }

  #create a hash just with the non legacy type value
  $newtype = $::rsyslog::config::global_config.filter |$key, $value| { ! has_key( $value, 'type')}

  #flatten the nested hash of hashes to one single hash
  $flattendata = $newtype.keys.reduce({}) |$memo, $key| { $memo + {$key => $newtype[$key]["value"]} }

  unless empty($flattendata) {
    concat::fragment { 'rsyslog::component::global_config::newtype':
      order   => $::rsyslog::global_config_priority,
      target  => "${::rsyslog::confdir}/${::rsyslog::target_file}",
      content => epp('rsyslog/global_config.epp',
      {
        'type'   => 'rainerscript',
        'config' => $flattendata,
      }),
    }
  }
}

