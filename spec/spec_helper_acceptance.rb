require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Configure all nodes in nodeset
  c.before :suite do
    install_module_on(hosts)
    install_module_dependencies_on(hosts)
  end
end

def cleanup_helper
  pp = <<-CLEANUP_MANIFEST
    package { 'rsyslog': ensure => absent }
    file { '/etc/rsyslog.d': ensure => absent, purge => true }
    file { '/etc/rsyslog.conf': ensure => absent }
  CLEANUP_MANIFEST

  apply_manifest(pp, catch_failures: true)
end
