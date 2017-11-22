require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::input', include_rsyslog: true do
  let(:title) { 'myinput' }

  context 'string input' do
    let(:params) do
      {
        type: 'imudp',
        priority: 40,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        config: {
          'port' => '514'
        }
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::input::myinput').with_content(
        %r{(?x)# myinput\n
        \s*input\(type="imudp"\s*\n
        \s*port="514"\s*\n
        \s*\)\s*}
      )
    end
  end
end
