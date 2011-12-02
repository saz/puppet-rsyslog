class rsyslog::client inherits rsyslog ($log_local = false, $log_auth_local = false, $custom_config = undef) {
	file { $rsyslog::params::client_conf:
		owner 	=> root,
		group 	=> root,
		ensure 	=> file,
        content => $custom_config ? {
            ''      => template("${module_name}/client.conf.erb"),
            default => template($custom_config),
        },
		require => Class['rsyslog::install'],
		notify 	=> Class['rsyslog::service'],
	}
}
