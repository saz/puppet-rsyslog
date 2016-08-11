require 'spec_helper'
describe 'rsyslog', :include_rsyslog => true do

  context 'with defaults for all parameters' do
    it { should contain_class('rsyslog') }
  end
end
