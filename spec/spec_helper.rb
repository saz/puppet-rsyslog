require 'puppetlabs_spec_helper/module_spec_helper'
require 'spec_helper'
require 'puppet'

RSpec.shared_context "rsyslog_class", :shared_context => :metadata do


    let(:pre_condition) { 
      <<-EOT
      class { 'rsyslog':
        confdir =>  '/etc/rsyslog.d',
        package_name =>  'rsyslog',
        package_version =>  'installed',
        manage_service => true,
        manage_package =>  true,
        manage_confdir =>  true,
        purge_config_files =>  true,
        override_default_config =>  true,
        config_file =>  '/etc/rsyslog.conf',
        service_name =>  'rsyslog',
        service_status =>  'running',
        service_enabled =>  true,
        feature_packages  => [],
        global_config_priority =>  10,
        module_load_priority =>  20,
        input_priority =>  30,
        main_queue_priority =>  40,
        parser_priority => 45,
        template_priority =>  50,
        action_priority =>  60,
        ruleset_priority => 65,
        legacy_config_priority =>  70,
        custom_priority =>  90,
        target_file =>  '50_rsyslog.conf',
      }
      EOT
    }
end

RSpec.configure do |rspec|
  rspec.include_context "rsyslog_class", :include_rsyslog => true
end



