# puppet-rsyslog

Manage rsyslog client and server via Puppet

## USAGE

### Client

#### Using default values
```
  class { 'rsyslog::client': }
```

#### imfile entries
Gathers log information from a file
```
  rsyslog::imfile { 'my-imfile':
    file_name     => '/some/file',
    file_tag      => 'mytag',
    file_facility => 'myfacility',
  }

```
#### rsyslog.d conf files

e.g. rsyslog.d/10-puppetagent.conf - moves puppet-agent entries to a file and excludes from /var/log/messages
```
  rsyslog::snippet { '10-puppetagent':
    content => ":programname,contains,\"puppet-agent\" /var/log/puppetlabs/puppet/puppet-agent.log\n& ~",
  }

```
#### Defining custom logging templates

The `log_templates` parameter can be used to set up custom logging templates, which can be used for local and/or remote logging. More detail on template formats can be found in the [rsyslog documentation](http://www.rsyslog.com/doc/rsyslog_conf_templates.html).

The following examples sets up a custom logging template as per [RFC3164fmt](https://www.ietf.org/rfc/rfc3164.txt):

```puppet
class{'rsyslog::client':
  log_templates => [
    {
      name      => 'RFC3164fmt',
      template  => '<%PRI%>%TIMESTAMP% %HOSTNAME% %syslogtag%%msg%',
    },
  ]
}
```

#### Logging to multiple remote servers

The `remote_servers` parameter can be used to set up logging to multiple remote servers which are supplied as a list of key value pairs for each remote. There is an example configuration provided in `./tests/multiple_hosts.pp`

Using the `remote_servers` parameter over-rides the other remote sever parameters, and they will not be used in the client configuration file:
* `log_remote`
* `remote_type`
* `server`
* `port`

The following example sets up three remote logging hosts for the client:

```puppet
class { 'rsyslog::client':
  remote_servers => [
    {
      host => 'logs.example.org',
    },
    {
      port => '55514',
    },
    {
      host      => 'logs.somewhere.com',
      port      => '555',
      pattern   => '*.log',
      protocol  => 'tcp',
      format    => 'RFC3164fmt',
    },
  ]
}
```

Each host has the following parameters:
* *host*: Sets the address or hostname of the remote logging server. Defaults to `localhost`
* *port*: Sets the port the host is listening on. Defaults to `514`
* *pattern*: Sets the pattern to match logs. Defaults to `*.*`
* *protocol*: Sets the protocol. Only recognises TCP and UDP. Defaults to UDP
* *format*: Sets the log format. Defaults to not specifying log format, which defaults to the format set by `ActionFileDefaultTemplate` in the client configuration.

#### Logging to a MySQL or PostgreSQL database

Events can also be logged to a MySQL or PostgreSQL database. The database needs to be deployed separately, either locally or remotely. Schema are available from the `rsyslog` source:

  * [MySQL schema](http://git.adiscon.com/?p=rsyslog.git;a=blob_plain;f=plugins/ommysql/createDB.sql)
  * [PostgreSQL schema](http://git.adiscon.com/?p=rsyslog.git;a=blob_plain;f=plugins/ompgsql/createDB.sql)

Declare the following to configure the connection:
````
  class { 'rsyslog::database':
    backend  => 'mysql',
    server   => 'localhost',
    database => 'Syslog',
    username => 'rsyslog',
    password => 'secret',
  }
````
### Server

#### Using default values
```
  class { 'rsyslog::server': }
```

### Log filter example (for Hiera)
```
rsyslog::client::log_filters:
  - expression: '$programname == "foo"'
    action: /var/log/foo.log
```

Both, client and server, can be installed at the same time.

#### Defining custom rules

The `rules` parameter can be used to set up custom rules. There is an example configuration provided in `./tests/rules.pp`

Using the `rules` parameter overrides the default rules. Each rule must have a selector and an action.

The following example sets up a server with three rules:

```puppet
class { '::rsyslog::server':
  rules => [
    {
      selector => 'auth,authpriv.*',
      action   => '?dynAuthLog',
    },
    {
      selector => 'cron.*',
      action   => '?dynCronLog',
    },
    {
      selector => '*.*;auth,authpriv.none,mail.none,cron.none',
      action   => '-?dynSyslog',
    },
  ],
}
```

Each rule has the following parameters:
* *selector*: Sets the selector field of the rule. Defaults to `undef`
* *action*: Sets the action field of the rule. Defaults to `undef`

### Other notes

By default, rsyslog::server will strip numbers from hostnames. This means the logs of
multiple servers with the same non-numerical name will be aggregrated in a single
directory. i.e. www01 www02 and www02 would all log to the www directory.

To log each host to a seperate directory, set the custom_config parameter to
'rsyslog/server-hostname.conf.erb'

If any of the following parameters are set to `false`, then the module will not
manage the respective package:

    gnutls_package_name
    relp_package_name
    rsyslog_package_name

This can be used when using the adiscon PPA repository, that has merged rsyslog-gnutls
with the main rsyslog package.

Default package_status parameter for rsyslog class used to be 'latest'. However, it was
against puppet best practices so it defaults to 'present' now.

#### Relationships

Be sure to make a relationship to the `rsyslog` class if you need something to happen before or after Puppet manages rsyslog. Even if you're just using `rsyslog::client` or `rsyslog::server`.

For example, if you want to make sure the EPEL YUM repositories are managed by Puppet before trying to setup an rsyslog client, do the following:

```puppet
include epel                       # This is from the stahnma/epel Forge module
include rsyslog::client

Class['epel'] -> Class['rsyslog']  # Note this forms a relationship to rsyslog, not rsyslog::client
```

