require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::legacy_config', include_rsyslog: true do
  let(:title) { 'mylegacy_rules' }

  context 'key/value legacy rules' do
    let(:params) do
      {
        priority: 40,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        key: 'auth,authpriv.*',
        value: '/var/log/auth.log'
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::legacy_config::mylegacy_rules').with_content(
        %r{(?x)# mylegacy_rules\n
        ^auth,authpriv\.\*\s*\/var\/log\/auth.log\s*\n
        }
      )
    end

    it { is_expected.to contain_class('rsyslog') }
    it { is_expected.to contain_concat('/etc/rsyslog.d/50_rsyslog.conf') }
    it { is_expected.to contain_rsyslog__generate_concat('rsyslog::concat::legacy_config::mylegacy_rules') }
  end

  context 'oneline legacy rules' do
    let(:params) do
      {
        priority: 40,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        type: 'legacy',
        value: '*.* @@logmonster.cloud.local'
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::legacy_config::mylegacy_rules').with_content(
        %r{(?x)# mylegacy_rules\n
        ^\*\.\*\s+@@logmonster.cloud.local\s*\n
        }
      )
    end
  end
end
