require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::property_filter', include_rsyslog: true do
  let(:title) { 'mypropertyfilter' }

  context 'initial test' do
    let(:params) do
      {
        priority: 55,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        property: 'msg',
        operator: 'contains',
        value: 'val',
        tasks: {
          action: {
            name: 'test_action',
            type: 'omfile',
            config: {
              dynaFile: 'remoteSyslog'
            }
          }
        }
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::property_filter::mypropertyfilter').with_content(
        <<-CONTENT
:msg, contains, "val"
  action(type="omfile"
    name="test-action"
    dynaFile="remoteSyslog"
  )
      CONTENT
      )
    end
  end
end