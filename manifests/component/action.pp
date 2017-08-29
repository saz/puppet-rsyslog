define rsyslog::component::action (
  Integer           $priority,
  String            $target,
  String            $confdir,
  String            $type,
  Optional[Hash]    $config,
  Optional[String]  $facility = 'default',
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/action.epp', {
        'action_name' => $name,
        'type'        => $type,
        'facility'    => $facility,
        'config'      => $config,
  })

  rsyslog::generate_concat { "rsyslog::concat::action::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::action::${name}"],
  }

  concat::fragment {"rsyslog::component::action::${name}":
    target  => "${::rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
