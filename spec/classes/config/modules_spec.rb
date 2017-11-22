require 'spec_helper'

describe 'rsyslog::server', include_rsyslog: true do
  let(:params) do
    {
      modules: { 'imuxsock' => {} }
    }
  end

  describe 'rsyslog::config::modules' do
    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('rsyslog::config::modules') }
    end
  end
end
