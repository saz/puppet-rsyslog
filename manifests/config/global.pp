class rsyslog::config::global {

  $configs = $rsyslog::global_config
  $target  = "${rsyslog::confdir}/${rsyslog::global_config_priority}_global.conf"

  concat { $target:
    owner  => 'root',
  }

  $configs.each |$confitem, $data| {
    concat::fragment { "rsyslog::global::${confitem}":
      target  => $target,
      content => epp("rsyslog/global_config.epp", { 
                       "type" => "rainerscript",  
                       "config_item" =>  $confitem 
                     } + $data)
    }
  }
}

