# puppet-rsyslog

Manage rsyslog client and server via Puppet

## How to use

### Client
```
    include rsyslog::client
```

Default server name is set to 'log'

#### Using a different server
```
    $rsyslog_server = 'another-server'
    include rsyslog::client
```

### Server
```
    include rsyslog::server
```

Both can be installed at the same time.

#### Other variables
* $rsyslog_server_dir = '/srv/log/'

### Other notes

* rsyslog::client is logging through relp
* rsyslog::server is running relp, udp and tcp
