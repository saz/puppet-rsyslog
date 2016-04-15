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

### Main configuration

#### `rsyslog::confdir`
Specifies the main directory where the module will place all configuration files (default: rsyslogd)

###### `rsyslog::package_name`
The package to install (default: rsyslog)

#### `rsyslog::package_version`
Package version/state to install, (default: installed)

#### `rsyslog::feature_packages`
An array containing a list of extra packages (features) to install.

#### `rsyslog::manage_package`
Enable or disable managing the package (default: true)

#### `rsyslog::manage_confdir`
Enable or disable managing the configuration directory (confdir) (default: true)

#### `rsyslog::purge_config_files`
When `rsyslog::manage_confdir` is set to true, this option defines whether or not to purge unmanaged files within the configuration directory (default: true)

#### `rsyslog::config_file`
Location of rsyslog main configuration file (default: /etc/rsyslog.conf)

#### `rsyslog::override_default_config`
When set to true, the default configuration file is overridden with just an include statement to the configuration directory .d (default: true)

#### `rsyslog::service_name`
Name of the service (default: rsyslog)

#### `rsyslog::service_status`
State of the service (default: running)

#### `rsyslog::service_enabled`
Whether or not to enable the service (default: true)

