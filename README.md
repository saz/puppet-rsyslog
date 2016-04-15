# rsyslog

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with rsyslog](#setup)
    * [What rsyslog affects](#what-rsyslog-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rsyslog](#beginning-with-rsyslog)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module manages the rsyslog server and client configuration. It supports rsyslog v8 and defaults to configuring most things in the newer rainerscript configuration style.  Where possible, common configuration patterns have been abstracted so they can be defined in a structured way from hiera.  Though there are a lot of customization options with the configuration, highly complex rsyslog configurations are not easily represented in simple data structures and in these circumstances you may have to provide raw rainerscript code to acheive what you need.  However, the aim of this module is to abstract as much as possible.

This module is only compatible with Puppet 4.0.0+

## Public classes

### rsyslog
### rsyslog::server
### rsyslog::client


## Configuration

Configuration options should be configured in Hiera

### Main system configuration

##### `rsyslog::confdir`
Specifies the main directory where the module will place all configuration files (default: rsyslogd)

##### `rsyslog::package_name`
The package to install (default: rsyslog)

##### `rsyslog::package_version`
Package version/state to install, (default: installed)

##### `rsyslog::feature_packages`
An array containing a list of extra packages (features) to install.

##### `rsyslog::manage_package`
Enable or disable managing the package (default: true)

##### `rsyslog::manage_confdir`
Enable or disable managing the configuration directory (confdir) (default: true)

##### `rsyslog::purge_config_files`
When `rsyslog::manage_confdir` is set to true, this option defines whether or not to purge unmanaged files within the configuration directory (default: true)

##### `rsyslog::config_file`
Location of rsyslog main configuration file (default: /etc/rsyslog.conf)

##### `rsyslog::override_default_config`
When set to true, the default configuration file is overridden with just an include statement to the configuration directory .d (default: true)

##### `rsyslog::service_name`
Name of the service (default: rsyslog)

##### `rsyslog::service_status`
State of the service (default: running)

##### `rsyslog::service_enabled`
Whether or not to enable the service (default: true)

### Rsyslog Configuration Directives

##### Config file

By default, everything is configured in a single file under `$confdir` called 50_rsyslog.conf.  This means that packages and other OS specific configurations can also be included (see purge_config_files above).  The default file can be changed using the `rsyslog::target_file` directive and is relative to the confdir.

eg:
```yaml
rsyslog::target_file: 50_rsyslog.conf
```


##### Ordering 

The following configuration parameters are defaults for the order of configuration object types within the configuration file.  They can be overriden for individual object definitions (see configuring objects below)

```yaml
## Default object type priorities (can be overridden)
rsyslog::module_load_priority: 10
rsyslog::input_priority: 15
rsyslog::global_config_priority: 20
rsyslog::main_queue_priority: 25
rsyslog::template_priority: 30
rsyslog::action_priority: 40
rsyslog::custom_priority: 90
```

### Configuring Objects

Configuration objects are written to the configuration file in rainerscript format and can be configured in a more abstract way directly from Hiera.     The following configuration object types are supported

* Modules
* Inputs
* Global configuration
* Main queue options
* Templates
* Actions

##### `rsyslog::modules`

An array of modules to load

```yaml
rsyslog::modules:
  - imuxsock
  - imklog
```

This will generate rainerscript as

```
module(load="imuxsock")
module(load="imklog")
```

##### `rsyslog::global_config`

A hash of hashes, they key represents the configuration setting and the value is a hash with the following keys:
* `value`: the value of the setting
* `type`: the type of format to use (legacy or rainerscript), if omitted rainerscript is used.

```yaml
rsyslog::global_config:
  parser.SomeConfigurationOption:
    value: 'on'
  EscapeControlCharactersOnReceive:
    value: 'off'
    type: legacy
```

```
global (
  parser.SomeConfigurationOption="on"
)
$EscapeControlCharactersOnReceive off
```

##### `rsyslog::main_queue_opts`
Configures the `main_queue` object in rsyslog as a hash

```yaml
rsyslog::main_queue_opts:
  queue.maxdiskspace: 1000G
  queue.dequeuebatchsize: 1000
```

```
main_queue(
  queue.maxdiskspace="1000G"
  queue.dequeuebatchsize="1000"
)
```

##### `rsyslog::templates`
Configures `template` objects in rsyslog.  Each element is a hash containing the name of the template, the type and the template data.    The type parameter can be one of `string`, `subtree`, `plugin` or `list`

```yaml
rsyslog::templates:
  remote:
    type: string
    string: "/var/log/rsyslog/logs/%fromhost-ip%/%fromhost-ip%.log"
  tpl2:
    type: subtree
    subtree: "$1!$usr"
  someplug:
     type: plugin
     plugin: foobar
```

eg:

```
template (name="remote" type="string"
  string="/var/log/rsyslog/logs/%fromhost-ip%/%fromhost-ip%.log"
)
```

When using `list`, the `list_descriptions` hash should contain an array od single element hashes, the key should be `constant` or `property` with their corresponding parameters in a sub hash.  eg:

```yaml
  plain-syslog:
    type: list
    list_descriptions:
      - constant:
          value: '{'
      - constant:
          value: '\"@timestamp\":\"'
      - constant:
          value: '\"@remove_me_timestamp\":\"'
      - property:
         name: timereported
         dateFormat: rfc3339
      - constant:
         value: '\"host\":\"'
      - property:
         name: hostname
      - constant:
         value: '\"severity\":\"'
      - property:
         name: syslogseverity-text
      - constant:
         value: '\"facility\":\"'
      - property:
         name: syslogfacility-text
      - constant:
         value: '\"tag\":\"'
      - property:
         name: syslogtag
         format: json
      - constant:
         value: '\"message\":\"'
      - property:
         name: msg
         format: json
      - constant:
         value: '\"}'
```

