class rsyslog::server inherits rsyslog {
    file { $rsyslog::params::server_conf:
        owner   => root,
        group   => root,
        ensure  => file,
        content => template("${module_name}/server.conf.erb"),
        require => Class['rsyslog::install'],
        notify  => Class['rsyslog::service'],
    }
}
