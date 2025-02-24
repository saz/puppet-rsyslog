# @summary
#   This class manages rsyslog database connection
#
# @example Puppet usage
#   class { 'rsyslog::database':
#     backend  => 'mysql',
#     server   => 'localhost',
#     database => 'mydb',
#     username => 'myuser',
#     password => 'mypass',
#   }
#
# @param backend
#   The database backend to use.
#
# @param server
#   The database server to use.
#
# @param database
#   The database name to use.
#
# @param username
#   The database username to use.
#
# @param password
#   The database password to use.
#
class rsyslog::database (
  Enum['mysql', 'pgsql'] $backend,
  Stdlib::Host $server,
  String[1] $database,
  String[1] $username,
  Variant[String[1], Sensitive[String[1]]] $password,
) {
  include rsyslog

  case $backend {
    'mysql': { $db_package = $rsyslog::mysql_package_name }
    'pgsql': { $db_package = $rsyslog::pgsql_package_name }
    default: { fail("Unsupported backend: ${backend}. Only MySQL (mysql) and PostgreSQL (pgsql) are supported.") }
  }

  if $db_package {
    package { $db_package:
      ensure => $rsyslog::package_status,
      before => Rsyslog::Snippet[$backend],
    }
  }

  rsyslog::snippet { $backend:
    ensure    => present,
    file_mode => '0600',
    content   => template("${module_name}/database.conf.erb"),
  }
}
