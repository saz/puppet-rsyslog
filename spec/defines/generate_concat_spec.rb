require 'spec_helper'

describe 'Rsyslog::Generate_concat', include_rsyslog: true do
  let(:pre_condition) { 'include rsyslog' }
  let(:title) { 'mygeneratedconcat' }

  let(:params) do
    {
      confdir: '/etc/rsyslog.d',
      target: '50-rsyslog.conf'
    }
  end

  context 'with defaults' do
    it { is_expected.to contain_concat('/etc/rsyslog.d/50-rsyslog.conf').that_notifies('Service[rsyslog]') }
  end
end
