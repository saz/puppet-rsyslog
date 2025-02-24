# @summary
#   This class manages extra rsyslog modules
#
# @example Puppet usage
#   class { 'rsyslog::modload': }
#
# @param modload_filename
#   Snippet filename to use
#
class rsyslog::modload (
  String[1] $modload_filename = '10-modload',
) {
  rsyslog::snippet { $modload_filename:
    ensure  => present,
    content => template('rsyslog/modload.erb'),
    require => Class['rsyslog::install'],
  }
}
