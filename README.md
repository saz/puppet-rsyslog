# puppet-rsyslog

Manage rsyslog client and server via Puppet

## How to use

### Client
#### Using default values
```
    class { 'rsyslog::client': }
```

#### Variables and default values
```
    class { 'rsyslog::client':
        log_local      => false,
        log_auth_local => false,
        custom_config  => undef,
        server         => 'log',
    }
```

### Server
#### Using default values
```
    class { 'rsyslog::server': }
```

#### Variables and default values
```
    class { 'rsyslog::server':
        enable_tcp                => true,
        enable_udp                => true,
        server_dir                => '/srv/log/',
        custom_config             => undef,
        high_precision_timestamps => false,
    }
```

Both can be installed at the same time.

### Other notes

* rsyslog::client is logging through relp
