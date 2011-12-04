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
        log_remote     => true,
        remote_type    => 'tcp',
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

Due to a missing feature in current RELP versions (InputRELPServerBindRuleset option),
remote logging is using TCP. You can switch between TCP and UDP. As soon as there is
a new RELP version which supports setting Rulesets, I will add support for relp back.
