define rsyslog::generate_concat (
  String $confdir,
  String $target,
) {
  if $::rsyslog::manage_service {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner  => 'root',
        notify => Service[$::rsyslog::service_name],
      }
    }
  } else {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner => 'root',
      }
    }
  }
}
