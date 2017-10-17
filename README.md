[![Build Status](https://travis-ci.org/crayfishx/puppet-rsyslog.svg?branch=master)](https://travis-ci.org/crayfishx/puppet-rsyslog)



# rsyslog

#### Table of Contents

* [Description](#description)
* [Usage](#usage)
* [Public Classes](#public-classes)
* [Configuration](#configuration)
  * [Main system configuration](#main-system-configuration)
  * [Rsyslog configuration directives](#rsyslog-configuration-directives)
  * [Configuring objects](#configuring-options)
    * [Modules](#rsyslogservermodules)
    * [global_config](#rsyslogserverglobal_config-rsyslogclientglobal_config)
    * [Queue options](#rsyslogservermain_queue_opts)
    * [Templates](#rsyslogservertemplates)
    * [Actions](#rsyslogserveractions-rsyslogclientactions)
    * [Inputs](#rsyslogserverinputs-rsyslogclientinputs)
    * [Lookup_tables](#rsyslogserverlookup_tables)
    * [Parser](#rsyslogserverparser)
    * [Rulesets](#rsyslogserverrulesets)
    * [legacy_config](#rsyslogserverlegacy_config)
  * [Positioning](#positioning)
  * [Formatting](#formatting)

    

## Description

This module manages the rsyslog server and client configuration. It supports rsyslog v8 and defaults to configuring most things in the newer rainerscript configuration style.  Where possible, common configuration patterns have been abstracted so they can be defined in a structured way from hiera.  Though there are a lot of customization options with the configuration, highly complex rsyslog configurations are not easily represented in simple data structures and in these circumstances you may have to provide raw rainerscript code to acheive what you need.  However, the aim of this module is to abstract as much as possible.

This module is only compatible with Puppet 4.0.0+

## Usage

Simply include the `rsyslog::client` or `rsyslog::server` class

```puppet
class { 'rsyslog::server': }
```

## Public classes

### rsyslog

Configures base rsyslog packages, service and general configuration

### rsyslog::server

Configuration directives for a server

### rsyslog::client

Configuration directives for a client

## Configuration

Configuration options should be configured in Hiera.  Defaults are defined in data/common.yaml within the module

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

##### `rsyslog::manage_service`
Manage the service or not (default: true)

##### `rsyslog::service_name`
Name of the service (default: rsyslog)

##### `rsyslog::service_status`
State of the service (default: running)

##### `rsyslog::service_enabled`
Whether or not to enable the service (default: true)

##### `rsyslog::external_service`
Whether or not to use an external service, be it managed by another module (such as a container service managed by `garethr-docker`) or unmanaged. MUST be used with `rsyslog::service_name` and cannot be used with `rsyslog::manage_service`. (default: false)

### Rsyslog Configuration Directives

##### Config file

By default, everything is configured in a single file under `$confdir` called 50_rsyslog.conf.  This means that packages and other OS specific configurations can also be included (see purge_config_files above).  The default file can be changed using the `rsyslog::target_file` directive and is relative to the confdir.

eg:
```yaml
rsyslog::target_file: 50_rsyslog.conf
```
You can, however, define custom confdirs and/or custom paths for configuration files. All configuration options have the following global options you can add to their hiera keys:

* `priority` - Order in the file to place the config value relative to the other config options in the file. Takes an integer. Defaults to the priority set for the configuration type. See [Ordering](#Ordering) for more.
* `target` - Target file to place the config values in. Defaults to 50_rsyslog.conf in the default `$confdir`.
* `confdir` - Target configuration directory. Defaults to `/etc/rsyslog.d`.



##### Ordering 

The following configuration parameters are defaults for the order of configuration object types within the configuration file.  They can be overriden for individual object definitions (see configuring objects below)

```yaml
## Default object type priorities (can be overridden)
rsyslog::global_config_priority: 10
rsyslog::module_load_priority: 20
rsyslog::input_priority: 30
rsyslog::main_queue_priority: 40
rsyslog::parser_priority: 45
rsyslog::template_priority: 50
rsyslog::action_priority: 60
rsyslog::ruleset_priority: 65
rsyslog::lookup_table_priority: 70
rsyslog::legacy_config_priority: 80
rsyslog::custom_priority: 90
```

### Configuring Objects

Configuration objects are written to the configuration file in rainerscript format and can be configured in a more abstract way directly from Hiera.     The following configuration object types are supported

* [Modules](#rsyslogservermodules)
* [Global configuration](#rsyslogserverglobal_config-rsyslogclientglobal_config)
* [Main queue options](#rsyslogservermain_queue_opts)
* [Templates](#rsyslogservertemplates)
* [Actions](#rsyslogserveractions-rsyslogclientactions)
* [Inputs](#rsyslogserverinputs-rsyslogclientinputs)
* [Lookup_tables](#rsyslogserverlookup_tables)
* [Parser](#rsyslogserverparser)
* [Rulesets](#rsyslogserverrulesets)
* [legacy_config](#rsyslogserverlegacy_config)

Configuration objects should be declared in the rsyslog::server or rsyslog::client namespaces accordingly.

##### `rsyslog::server::modules`

A hash of hashes, hash key represents the module name and accepts a hash with values or an empty hash as its value.
The hash accepts the following three values:
* `type`: values can be `external or builtin` the default value is external and need not be specified explicitly.
* `config`: its a hash which provides optional parameters to the module loaded.
* `priority`: The module load order can be priortised based on the optional `priority` value.

eg:
```yaml
rsyslog::server::modules:
  imuxsock: {}
  imudp:
    config:
      threads: "2"
      TimeRequery: "8"
      batchSize: "128"
  omusrmsg:
    type: "builtin"
  omfile:
    type: "builtin"
    config:
      fileOwner: "syslog"
      fileGroup: "adm"
      dirGroup: "adm"
      fileCreateMode: "0640"
      dirCreateMode: "0755" 
  impstats:
    type: "external"
    priority: 29
    config:
      interval: "60"
      severity: "7"
      log.syslog: "off"
      log.file: "/var/log/rsyslog/logs/stats/stats.log"
      Ruleset: "remote"
```

will produce

```
module (load="imuxsock")
module (load="imudp"
           threads="2"
           TimeRequery="8"
           batchSize="128"

)
module (load="builtin:omusrmsg")
module (load="builtin:omfile"
           fileOwner="syslog"
           fileGroup="adm"
           dirGroup="adm"
           fileCreateMode="0640"
           dirCreateMode="0755"

)
module (load="impstats"
           interval="60"
           severity="7"
           log.syslog="off"
           log.file="/var/log/rsyslog/logs/stats/stats.log"
           Ruleset="remote"

)
```

##### `rsyslog::server::global_config` `rsyslog::client::global_config`

A hash of hashes, they key represents the configuration setting and the value is a hash with the following keys:
* `value`: the value of the setting
* `type`: the type of format to use (legacy or rainerscript), if omitted rainerscript is used.

eg:
```yaml
rsyslog::server::global_config:
  umask:
    value: '0000'
    type: legacy
    priority: 01
  RepeatedMsgReduction:
    value: 'on'
    type: legacy
  PrivDropToUser:
    value: 'syslog'
    type: legacy
  PrivDropToGroup:
    value: 'syslog'
    type: legacy
  parser.escapeControlCharactersOnReceive:
    value: 'on'
  workDirectory:
    value: '/var/spool/rsyslog'
  maxMessageSize:
    value: '64k'
```

will produce

```
$umask 0000
$PrivDropToGroup syslog
$PrivDropToUser syslog
$RepeatedMsgReduction on
global (
    parser.escapeControlCharactersOnReceive="on"
    workDirectory="/var/spool/rsyslog"
    maxMessageSize="64k"
  
)
```

##### `rsyslog::server::main_queue_opts`
Configures the `main_queue` object in rsyslog as a hash. eg:

```yaml
rsyslog::server::main_queue_opts:
  queue.maxdiskspace: 1000G
  queue.dequeuebatchsize: 1000
```

will produce

```
main_queue(
  queue.maxdiskspace="1000G"
  queue.dequeuebatchsize="1000"
)
```

##### `rsyslog::server::templates`
Configures `template` objects in rsyslog.  Each element is a hash containing the name of the template, the type and the template data.    The type parameter can be one of `string`, `subtree`, `plugin` or `list`

eg:
```yaml
rsyslog::server::templates:
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

will produce

```
template (name="remote" type="string"
  string="/var/log/rsyslog/logs/%fromhost-ip%/%fromhost-ip%.log"
)
```

When using `list`, the `list_descriptions` hash should contain an array of single element hashes, the key should be `constant` or `property` with their corresponding parameters in a sub hash.

eg:
```yaml
  plain-syslog:
    type: list
    list_descriptions:
      - constant:
          value: '{'
      - constant:
          value: '\"@timestamp\":\"'
      - property:
         name: timereported
         dateFormat: rfc3339
      - constant:
         value: '\",\"host\":\"'
      - property:
         name: hostname
      - constant:
         value: '\",\"severity\":\"'
      - property:
         name: syslogseverity-text
      - constant:
         value: '\",\"facility\":\"'
      - property:
         name: syslogfacility-text
      - constant:
         value: '\",\"tag\":\"'
      - property:
         name: syslogtag
         format: json
      - constant:
         value: '\",\"message\":\"'
      - property:
         name: msg
         format: json
      - constant:
         value: '\"}'
```

will produce

```
template (name="plain-syslog" type="list"
)
{
    constant(value="{" )
    constant(value="\"@timestamp\":\"" )
    property(name="timereported" dateFormat="rfc3339" )
    constant(value="\",\"host\":\"" )
    property(name="hostname" )
    constant(value="\",\"severity\":\"" )
    property(name="syslogseverity-text" )
    constant(value="\",\"facility\":\"" )
    property(name="syslogfacility-text" )
    constant(value="\",\"tag\":\"" )
    property(name="syslogtag" format="json" )
    constant(value="\",\"message\":\"" )
    property(name="msg" format="json" )
    constant(value="\"}" )
}

```

##### `rsyslog::server::actions` `rsyslog::client::actions`
Configures action objects in rainerscript.  Each element of the hash contains the type of action, followed by a hash of configuration options.
It also accepts an optional facility parameter and the content is formatted based on the no of config options passed and if the facility option is present.

eg:
```yaml
rsyslog::server::actions:
  all_logs:
    type: omfile
    facility: "*.*;auth,authpriv.none"
    config:
      dynaFile: "remoteSyslog"
      specifics: "/var/log/test"
  kern_logs:
    type: omfile
    facility: "kern.*"
    config:
      dynaFile: "remoteSyslog"
      file: "/var/log/kern.log"
      cmd: "/proc/cmdline"
  elasticsearch:
    type: omelasticsearch
    config:
      queue.type: "linkedlist"
      queue.spoolDirectory: /var/log/rsyslog/queue
```

will produce

```
#Note: There is only 2 options passed so formats in a single line.
# all_logs
*.*;auth,authpriv.none         action(type="omfile" dynaFile="remoteSyslog" specifics="/var/log/test" )

#Note: There is more than 2 options passed so formats into multi line with facility.
# kern_logs
kern.*                         action(type="omfile"
                                 dynaFile="remoteSyslog"
                                 file="/var/log/kern.log"
                                 cmd="/proc/cmdline"
                               )

#Note: There is no facility option passed so formats it without facility.
action(type="omelasticsearch"
  queue.type="linkedlist"
  queue.spoolDirectory="/var/log/rsyslog/queue"
)
```


##### `rsyslog::server::inputs` `rsyslog::client::inputs`
Configures input objects in rainerscript.  Each element of the hash contains the type of input, followed by a hash of configuration options. Eg:

```yaml
rsyslog::server::inputs:
  imudp:
    type: imudp
    config:
      port: '514'
```

will produce

```
input(type="imudp"
  port="514"
)
```

##### `rsyslog::server::lookup_tables`
Configures lookup_tables objects in rainerscript AND generates the JSON lookup_table file. Each key of the hash contains the name of the lookup/lookup_table.
The elements of the hash contain a `json` hash containing the values for the JSON file, a lookup_file element that is the path to where the JSON file will be stored,
and a reload_on_hup boolean.

The json hash contains 4 elements: `version`, `nolookup`, `type`, and `table`. They **MUST** be specified in this order as per the
[lookup_tables documentation](http://www.rsyslog.com/doc/v8-stable/configuration/lookup_tables.html):

* `version` - Integer denoting the version/revision of the lookup_table file.
* `nolookup` - String denoting what should be returned if a lookup doesn't find a match in the table.
* `type` - Enumerable denoting the type of lookup table. This can be `string`, `array`, or `sparseArray`.
* `table` - An Array of hashes containing the table index and value for each lookup.


```yaml
rsyslog::server::lookup_tables:
  ip_lookup:
    json:
      version: 1
      nolookup: 'unk'
      type: 'string'
      table:
        - index: '1.1.1.1'
          value: 'AB'
        - index: '2.2.2.2'
          value: 'CD'
    lookup_file: '/etc/rsyslog.d/tables/ip_lookup.json'
    reload_on_hup: true
```

will produce

```json
# /etc/rsyslog.d/tables/ip_lookup.json
{
  "version": 1,
  "nomatch": "unk",
  "type": "string",
  "table": [
    {
      "index": "1.1.1.1",
      "value": "A"
    },
    {
      "index": "2.2.2.2",
      "value": "B"
    }
  ]
}
```

and

```
lookup_table(name="ip_lookup" file="/etc/rsyslog.d/tables/ip_lookup.json" reloadOnHUP="on")
```

NOTE: This does not create the actual `lookup()` call in the Rsyslog configuration file(s). Currently that is only supported via
the `rsyslog::server::custom_config` and `rsyslog::client::custom_config` resources as it requires setting rsyslog variables (I.E. - `set $.iplook = lookup('ip_lookup', $hostname)`).

##### `rsyslog::server::parser`

Configures parser objects in rainerscript. Each Element of the hash contains the type of parser, followed by a hash of configuration options. Eg:

```yaml
rsyslog::server::parser:
  pmrfc3164_hostname_with_slashes:
    type: pmrfc3164
    config:
      permit.slashesinhostname: 'on'
```

will produce

```
parser(name="pmrfc3164_hostname_with_slashes"
       type="pmrfc3164"
       permit.slashesinhostname="on"
)
```

##### `rsyslog::server::rulesets`

Configures Rsyslog ruleset blocks in rainerscript. There are two elements in the rulesets hash:
* `parameters` - settings to pass to the ruleset determining things such as which rsyslog parser to use or the ruleset's queue size.
* `rules` - the actual content that goes inside the ruleset. Currently the following are supported:
    * `action` - rsyslog actions defined inside of the ruleset.
    * `lookup` - Sets a variable to the results of an rsyslog lookup.
    * `set` - Set an rsyslog variable
    * `call` - call a specific action.
* `stop` - a Boolean to set if the ruleset ends with a stop or not.
    
```yaml
rsyslog::server::rulesets:
  ruleset_eth0_514_tcp:
    parameters:
      parser: pmrfc3164.hostname_with_slashes
      queue.size: '10000'
    rules:
      - set:
          rcv_time: 'exec_template("s_rcv_time")'
      - set:
          utime_gen: 'exec_template("s_unixtime_generated")'
      - set:
          uuid: '$uuid'
      - action:
          name: utf8-fix
          type: mmutf8fix
      - action:
          name: test-action
          type: omfile
          facility: "*.*;auth,authpriv.none"
          config:
            dynaFile: "remoteSyslog"
            specifics: "/var/log/test"
      - action:
          name: test-action2
          type: omfile
          config:
            dynaFile: "remoteSyslog"
            specifics: "/var/log/test"
      - lookup:
          var: srv
          lookup_table: srv-map
          expr: '$fromhost-ip'
      - call: 'action.parse.rawmsg'
      - call: 'action.parse.r_msg'
    stop: true
```

Will produce:

```
ruleset (name="ruleset_eth0_514_tcp"
  parser="pmrfc3164.hostname_with_slashes"
  queue.size="10000"
) {
  set $.rcv_time = exec_template("s_rcv_time");
  set $.utime_gen = exec_template("s_unixtime_generated");
  set $.uuid = $uuid;
  # utf8-fix action
  action(type="mmutf8fix"
    name="utf8-fix"
  )
  # test-action action
*.*;auth,authpriv.none         action(type="omfile" 
                                 name="test-action"
                                 dynaFile="remoteSyslog"
                                 specifics="/var/log/test"
                               )
  # test-action2 action
  action(type="omfile"
    name="test-action2"
    dynaFile="remoteSyslog"
    specifics="/var/log/test"
  )
  set $.srv = lookup("srv-map", $fromhost-ip);
  call action.parse.rawmsg
  call action.parse.r_msg
  stop
}

```

##### `rsyslog::server::legacy_config`

Legacy config support is provided to facilitate backwards compatibility with `sysklogd` format as this module mainly supports `rainerscript` format.

A hash of hashes, each hash name is used as the comment/reference for the setting and the hash will have the following values:
* `key`: the key/logger rule setting
* `value`: the value/target of the setting
* `type`: the type of format to use (legacy or sysklogd), if omitted sysklogd is used. If legacy type is used `key` can be skipped and one long string can be provided as value.

eg:
```yaml
rsyslog::client::legacy_config:
  auth_priv_rule:
    key: "auth,authpriv.*"
    value: "/var/log/auth.log"
  auth_none_rule:
    key: "*.*;auth,authpriv.none"
    value: "/var/log/syslog"
  syslog_all_rule:
    key: "syslog.*"
    value: "/var/log/rsyslog.log"
  mail_error_rule:
    key: "mail.err"
    value: "/var/log/mail.err"
  news_critical_rule:
    key: "news.crit"
    value: "/var/log/news/news.crit"
```

will produce

```
# auth_priv_rule
auth,authpriv.*    /var/log/auth.log

# auth_none_rule
*.*;auth,authpriv.none    /var/log/syslog

# syslog_all_rule
syslog.*    /var/log/rsyslog.log

# mail_error_rule
mail.err    /var/log/mail.err

# news_critical_rule
news.crit    /var/log/news/news.crit

```
legacy type values can be passed as one long string skipping the key parameter like below and you can also override the priority in the hash to rearrange the contents 
eg:
```
  emergency_rule:
    key: "*.emerg"
    value: ":omusrmsg:*"
  testing_legacy_remotelog:
    value: "*.* @@logmonster.cloudfront.net:1514"
    type: "legacy"
    priority: 12
  testing_legacy_rule:
    value: "*.* >dbhost,dbname,dbuser,dbpassword;dbtemplate"
    type: "legacy"

```

will produce

```
# emergency_rule
*.emerg    :omusrmsg:*

# testing_legacy_rule
*.* >dbhost,dbname,dbuser,dbpassword;dbtemplate

# testing_legacy_remotelog
*.* @@logmonster.cloudfront.net:1514

```

### Positioning
All rsyslog object types are positioned according to the default variables (see [Ordering](#ordering)).  The position can be overridden for any object by adding the optional `priority` parameter.

eg:
```yaml
rsyslog::server::actions:
  elasticsearch:
    type: omelasticsearch
    config:
      queue.type: "linkedlist"
      queue.spoolDirectory: "/var/log/rsyslog/queue"
    priority: 35
```

### Formatting

This module attempts to abstract rainerscript objects into data structures that can be handled easily within hiera, however there are clearly times when you need to add some more code structure around an object, such as conditionals.  For simple code additions, the `template`, `action`, `input` and `global_config` object types support the optional parameter of `format` which takes Puppet EPP formatted template as a value, using the variable `$content` to signify the object itself.   For example, to wrap an action in a simple conditional you could format it as

eg:
```yaml
rsyslog::server::actions:
  elasticsearch:
    type: omelasticsearch
    config:
      queue.type: "linkedlist"
      queue.spoolDirectory: "/var/log/rsyslog/queue"
    format: |
      if [ $fromhost == "foo.localdomain"] then {
      <%= $content %>
      }
```

For more complicated code structures that don't lend themselves well to a structured format, like multiple nested conditionals there is also a special configuration object type called custom_config.    `custom_config` takes two arguments, `priority` to determine where in the file it should be configured, and `content` a text string to insert. By default the priority is set by the `custom_config_priority` parameter (see [Ordering](#ordering))

```yaml
rsyslog::server::custom_config:
  localhost_action:
    priority: 45
    content: |
      if $fromhost == ["foo.localdomain","localhost"] then {
        action(type="omfile" file="/var/log/syslog")
      } else {
       action(type="omelasticsearch"
         queue.type="linkedlist"
         queue.spoolDirectory="/var/log/rsyslog/queue"
       )
    }

  stop:
    content: |
      if [ $fromhost == "foo" ] then stop

```

### License

* This module is licensed under Apache 2.0, see LICENSE.txt for more details

### Maintainer

* Written and maintained by Craig Dunn (craig@craigdunn.org) @crayfishx
* Sponsored by [Skyscape Cloud Services](http://www.skyscapecloud.com)

