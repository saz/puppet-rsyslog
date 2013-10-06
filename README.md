# puppet-rsyslog [![Build Status](https://secure.travis-ci.org/saz/puppet-rsyslog.png)](https://travis-ci.org/saz/puppet-rsyslog)

Manage rsyslog client and server via Puppet

## REQUIREMENTS

* Puppet >=2.6 if using parameterized classes
* Currently supports Ubuntu >=11.04 & Debian running rsyslog >=4.5

## USAGE

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
        port           => '514',
    }
```
for read from file
```
 rsyslog::imfile { 'my-imfile':
   file_name => '/some/file',
   file_tag => 'mytag',
   file_facility => 'myfacility',
  }

```

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

#### Variables and default values
```
    class { 'rsyslog::server':
        enable_tcp                => true,
        enable_udp                => true,
        enable_onefile            => false,
        server_dir                => '/srv/log/',
        custom_config             => undef,
        high_precision_timestamps => false,
    }
```

Both can be installed at the same time.

## PARAMETERS

The following lists all the class parameters this module accepts.

    RSYSLOG::SERVER CLASS PARAMETERS    VALUES              DESCRIPTION
    -------------------------------------------------------------------
    enable_tcp                          true,false          Enable TCP listener. Defaults to true.
    enable_udp                          true,false          Enable UDP listener. Defaults to true.
    enable_onefile                      true,false          Only one logfile per remote host. Defaults to false.
    server_dir                          STRING              Folder where logs will be stored on the server. Defaults to '/srv/log/'
    custom_config                       STRING              Specify your own template to use for server config. Defaults to undef. Example usage: custom_config => 'rsyslog/my_config.erb'
    high_precision_timestamps           true,false          Whether or not to use high precision timestamps.

    RSYSLOG::CLIENT CLASS PARAMETERS    VALUES              DESCRIPTION
    -------------------------------------------------------------------
    log_remote                          true,false          Log Remotely. Defaults to true.
    remote_type                         'tcp','udp'         Which protocol to use when logging remotely. Defaults to 'tcp'.
    log_local                           true,false          Log locally. Defaults to false.
    log_auth_local                      true,false          Just log auth facility locally. Defaults to false.
    custom_config                       STRING              Specify your own template to use for client config. Defaults to undef. Example usage: custom_config => 'rsyslog/my_config.erb
    server                              STRING              Rsyslog server to log to. Will be used in the client configuration file.

    RSYSLOG::DATABASE CLASS PARAMETERS  VALUES              DESCRIPTION
    -------------------------------------------------------------------
    backend                             'mysql','pgsql'     Database backend (MySQL or PostgreSQL).
    server                              STRING              Database server.
    database                            STRING              Database name.
    username                            STRING              Database username.
    password                            STRING              Database password.

### Other notes

Due to a missing feature in current RELP versions (InputRELPServerBindRuleset option),
remote logging is using TCP. You can switch between TCP and UDP. As soon as there is
a new RELP version which supports setting Rulesets, I will add support for relp back.

By default, rsyslog::server will strip numbers from hostnames. This means the logs of
multiple servers with the same non-numerical name will be aggregrated in a single
directory. i.e. www01 www02 and www02 would all log to the www directory.

To log each host to a seperate directory, set the custom_config parameter to
'rsyslog/server-hostname.conf.erb'
