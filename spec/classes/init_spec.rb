require 'spec_helper'
describe 'rsyslog', include_rsyslog: true do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('rsyslog') }
  end
end
