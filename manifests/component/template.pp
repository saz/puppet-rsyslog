define rsyslog::component::template (
  Integer           $priority,
  String            $target,
  Enum[
    'string',
    'list',
    'subtree',
    'plugin'
  ]                 $type,
  Optional[Array]   $list_descriptions = [],
  Optional[String]  $string = '',
  Optional[String]  $subtree = '',
  Optional[String]  $plugin = '',
  Optional[Hash]    $options = {},
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/template.epp',
      {
        'string'            => $string,
        'list_descriptions' => $list_descriptions,
        'type'              => $type,
        'template_name'     => $name,
        'subtree'           => $subtree,
        'plugin'            => $plugin,
        'options'           => $options,
  })

  concat::fragment {"rsyslog::component::template::${name}":
    target  => "${rsyslog::confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }

}
