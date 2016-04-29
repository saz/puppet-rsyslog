require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'rake'
require 'rspec/core/rake_task'

PuppetLint.configuration.send("disable_80chars")    # no warnings on lines over 80 chars.
PuppetLint.configuration.ignore_paths = ["spec/fixtures/**/*.pp"]

task :default => [:spec, :lint]
