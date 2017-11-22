require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::global_config', include_rsyslog: true do
  let(:title) { 'configoption' }

  context 'when configuring a legacy type value' do
    let(:params) do
      {
        type: 'legacy',
        value: 'on',
        priority: 40,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d'
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::global_config::configoption').with_content(
        %r{(?x)\$configoption\s+on\s*\n}
      )
    end
  end
end
