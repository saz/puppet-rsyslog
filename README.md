# puppet-rsyslog
================

Manage rsyslog client and server via Puppet.

## REQUIREMENTS

* Puppet >=2.6 if using parameterized classes
* Currently supports:
    * Debian Squeeze
    * Ubuntu Oneric Ocelot 11.10
    * CentOS 6.2
    * FreeBSD

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
        servers         => ['log'],
        port           => '514',
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


## PARAMETERS

The following lists all the class parameters this module accepts.

    RSYSLOG::SERVER CLASS PARAMETERS    VALUES         DESCRIPTION
    --------------------------------------------------------------
    enable_tcp                          true,false     Enable TCP listener. Defaults to true.
    enable_udp                          true,false     Enable UDP listener. Defaults to true.
    server_dir                          STRING         Folder where logs will be stored on the server. Defaults to '/srv/log/'
    custom_config                       STRING         Specify your own template to use for server config. Defaults to undef. Example usage: custom_config => 'rsyslog/my_config.erb'
    high_precision_timestamps           true,false     Whether or not to use high precision timestamps.

    RSYSLOG::CLIENT CLASS PARAMETERS    VALUES         DESCRIPTION
    --------------------------------------------------------------
    log_remote                          true,false     Log Remotely. Defaults to true.
    remote_type                         'tcp','udp'    Which protocol to use when logging remotely. Defaults to 'tcp'.
    log_local                           true,false     Log locally. Defualts to false.
    log_auth_local                      true,false     Just log auth facility locally. Defaults to false.
    custom_config                       STRING         Specify your own template to use for client config. Defaults to undef. Example usage: custom_config => 'rsyslog/my_config.erb
    preserve_fqdn                       true,false      Sets the rsyslog client to try and send logs with the FQDN rather than an abbreviated host name.
    servers                             [STRING]        A list of rsyslog compatible servers to log to. Will be used in the client configuration file.

*NOTE:* Currently the client only works with a list of logging servers that have identical configurations.

## Server Compatibility

This puppet module has been confirmed to be compatible with the following logging services:
* rsyslog
* Graylog2 http://graylog2.org/

## Other notes

Due to a missing feature in current RELP versions (InputRELPServerBindRuleset option),
remote logging is using TCP. You can switch between TCP and UDP. As soon as there is
a new RELP version which supports setting Rulesets, I will add support for relp back.
