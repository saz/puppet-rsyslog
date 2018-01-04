require 'spec_helper'

describe 'Rsyslog::Server', include_rsyslog: true do
  let(:pre_condition) { 'include rsyslog' }

  context 'with defaults' do
    it { is_expected.to contain_class('rsyslog::server') }
    it {
      is_expected.to contain_class('rsyslog::config').with(
        global_config: {},
        legacy_config: {},
        actions: {},
        inputs: {},
        custom_config: {},
        modules: {},
        lookup_tables: {},
        parsers: {},
        rulesets: {},
        property_filters: {},
        expression_filters: {}
      )
    }
  end
end
