require 'spec_helper'

describe 'Rsyslog::Client', include_rsyslog: true do
  let(:pre_condition) { 'include rsyslog' }

  context 'with defaults' do
    it { is_expected.to contain_class('rsyslog::client') }
    it {
      is_expected.to contain_class('rsyslog::config').with(
        global_config: {},
        legacy_config: {},
        actions: {},
        inputs: {},
        custom_config: {},
        modules: {},
        lookup_tables: {}
      )
    }
  end
end
