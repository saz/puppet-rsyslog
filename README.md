# puppet-rsyslog
puppet-rsyslog is a module for puppet to manage rsyslog client and server

## How to use
```include rsyslog::client```

or

```
    $rsyslog_server_dir = "/path/to/target/directory/"
    include rsyslog::server
```

Both can be installed at the same time.

Default server name is 'log'.
$rsyslog_server_dir defaults to '/srv/log/'

### Setting a different server
```
    $rsyslog_server = "another.server.domain.tld"
    include rsyslog::client
```
