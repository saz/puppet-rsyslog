class rsyslog::client ($log_remote = true, $remote_type = 'tcp', $log_local = false, $log_auth_local = false, $custom_config = undef, $server = 'log') inherits rsyslog {
	file { $rsyslog::params::client_conf:
		ensure 	=> present,
		owner 	=> root,
		group 	=> root,
        content => $custom_config ? {
            ''      => template("${module_name}/client.conf.erb"),
            default => template($custom_config),
        },
		require => Class['rsyslog::config'],
		notify 	=> Class['rsyslog::service'],
	}
}
