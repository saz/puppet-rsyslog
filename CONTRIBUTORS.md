# Readme for Contributors

## Module Overview
  This is a rsyslog module which uses the concept of default hiera data in a 
  puppet module, the aim of the module is to abstract rsyslog configuration as
  much as possible into simple yaml configuration. The module is broken down
  granuarly to provide any custom configuration required.

## Module Layout
  The module is written as 2 main components one is is installing the package,
  configuring the service etc, with base install and the second is configuring 
  it as client/server based on the configuration data provided. The configuration 
  class is broken down into 7 classes

  - rsyslog::config::modules
  - rsyslog::config::global
  - rsyslog::config::main_queue
  - rsyslog::config::templates
  - rsyslog::config::actions
  - rsyslog::config::inputs
  - rsyslog::config::custom

  Each of the above classes accepts either an Array or Hash as its input. There
  are parts of configuration in rsyslog where having simple hash won't suit for
  complex configuration. so to facilate that few of the above mentioned classes
  accepts hash of hashes as its input and loops through that hash and passes
  the broken down small hash as the input to the specific component written for
  that class. The component or the custom definition creates content by passing 
  the values to epp template and uses concat module, config priority assigned 
  for that class and creates small snippets of configuration which is joined 
  together in the end by the concat module. 

## Example
  The below example shows what happens when `include rsyslog::config::global` class
  is called with the hiera data provided below. The class breaks down the hash
  and pass small set of hashes to the definition and creates the configuration shown
  below. For full list 

  ** Hiera Data **
  ```
  #common configuration
  rsyslog::global_config_priority: 20
  rsyslog::target_file: 50_rsyslog.conf
  rsyslog::confdir: /etc/rsyslog.d

  #configuration data for global_config class
  rsyslog::server::global_config:
  parser.SomeConfigurationOption:
    value: 'on'
  EscapeControlCharactersOnReceive:
    value: 'off'
    type: legacy
  ```

  ** global_config class **
  ```
  class rsyslog::config::global {
    $::rsyslog::config::global_config.each |$param, $config| {
      rsyslog::component::global_config { $param:
        * => {
          'priority' => $::rsyslog::global_config_priority,
          'target'   => $::rsyslog::target_file,
        } + $config,
      }
    }
  }
  ```

  ** Custom Definition/Component **
  ```
  define rsyslog::component::global_config (
    Integer           $priority,
    String            $target,
    String            $value,
    Optional[String]  $type = 'rainerscript',
    Optional[String]  $format = '<%= $content %>'
  ) {
  
    include rsyslog
  
    $content = epp('rsyslog/global_config.epp', {
          'config_item' => $name,
          'type'        => $type,
          'value'       => $value
    })
  
    concat::fragment {"rsyslog::component::global_config::${name}":
      target  => "${::rsyslog::confdir}/${target}",
      content => inline_epp($format),
      order   => $priority,
    }
  
  }
  ```

  ** EPP Template **
  ```
  <%- |
    String $value,
    String $config_item,
    Optional[String] $type
  | -%>
  <% if $type == 'legacy' { -%>
  $<%= $config_item %> <%= $value %>
  <% } else { -%>
  global (
    <%= $config_item %>="<%= $value %>"
  )
  <% } -%>
  ```

  ** Configuration Output **
  ```
  #The configuration output will be on multiple small files initially 
  #and will be joined together by the concat module based on priority
  global (
  parser.SomeConfigurationOption="on"
  )
  $EscapeControlCharactersOnReceive off
  ```
  Similarly the each of the config classes provide a piece of functionality.
  For full details on which class provides what functionaly in configuring 
  rsyslog please see the [README.md](./blob/master/README.md) file.

## Extending Module
  The module provides full flexiblity for custom configuration / extension,
  it can be easily extended to include any specific functionaly by assigning
  a priority for the class where the new functionality to be placed in the
  50_rsyslog.conf file or it can also be dropped as file into /etc/rsyslog.d
  directory. If the class/component/template structure is maintained as above
  explained it would make its usablity easier for everyone.
  
