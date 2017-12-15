require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::expression_filter', include_rsyslog: true do
  let(:title) { 'myexpressionfilter' }

  context 'initial test' do
    let(:params) do
      {
        priority: 55,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        conditionals: {
          if: {
            expression: 'msg == "test"',
            tasks: {
              action: {
                name: 'myaction',
                type: 'omfile',
                config: {
                  dynaFile: 'remoteSyslog'
                }
              }
            }
          },
          else: {
            tasks: {
              action: {
                name: 'myaction2',
                type: 'omfwd',
                config: {
                  KeepAlive: 'on'
                }
              }
            }
          }
        }
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::expression_filter::myexpressionfilter').with_content(
        <<-CONTENT
# myexpressionfilter
if msg == "test" {
# myaction
action(type="omfile"
  dynaFile="remoteSyslog"
)

}
else {
# myaction2
action(type="omfwd"
  KeepAlive="on"
)

}
      CONTENT
      )
    end
  end
end