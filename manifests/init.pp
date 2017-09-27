# Class: rsyslog
# ===========================
#
# Full description of class rsyslog here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'rsyslog':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class rsyslog (
  String  $confdir,
  String  $package_name,
  String  $package_version,
  String  $config_file,
  Array   $feature_packages,
  Integer $module_load_priority,
  String  $service_name,
  String  $service_status,
  Boolean $service_enabled,
  Boolean $override_default_config,
  Boolean $manage_package,
  Boolean $manage_confdir,
  Boolean $manage_service,
  Boolean $external_service,
  Boolean $purge_config_files,
  Integer $global_config_priority,
  Integer $legacy_config_priority,
  Integer $template_priority,
  Integer $action_priority,
  Integer $input_priority,
  Integer $custom_priority,
  Integer $main_queue_priority,
  Integer $lookup_table_priority,
  Integer $parser_priority,
  Integer $ruleset_priority,
  String  $target_file,
) {

  if $manage_service == true and $external_service == true {
    fail('manage_service and external_service cannot be set at the same time!')
  } else {
    class { 'rsyslog::base': }
  }

}
