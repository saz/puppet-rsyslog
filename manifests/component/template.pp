define rsyslog::component::template (
  Integer           $priority,
  Enum['string',
       'list',
       'subtree',
       'plugin']    $type,
  Optional[Array]   $list_descriptions = [],
  Optional[String]  $string = '',
  Optional[String]  $subtree = '',
  Optional[String]  $plugin = '',
  Optional[Hash]    $options = {},
) {

  include rsyslog

  
  file { "${::rsyslog::confdir}/${priority}_${name}_template.conf":
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    content  => epp('rsyslog/template.epp',
      {
        "string"            => $string,
        "list_descriptions" => $list_descriptions,
        "type"              => $type,
        "template_name"     => $name,
        "subtree"           => $subtree,
        "plugin"            => $plugin,
        "options"           => $options,
      }),
  }

}
