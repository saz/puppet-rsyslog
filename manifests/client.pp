class rsyslog::client inherits rsyslog {
	file { $rsyslog::params::client_conf:
		owner 	=> root,
		group 	=> root,
		ensure 	=> file,
		content	=> template("${module_name}/client.conf.erb"),
		require => Class['rsyslog::install'],
		notify 	=> Class['rsyslog::service'],
	}
}
