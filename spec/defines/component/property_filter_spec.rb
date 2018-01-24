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
            name: 'myaction',
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
# mypropertyfilter
:msg, contains, "val" {
# myaction
action(type="omfile"
  dynaFile="remoteSyslog"
)

}
        CONTENT
      )
    end

    it { is_expected.to contain_class('rsyslog') }
    it { is_expected.to contain_concat('/etc/rsyslog.d/50_rsyslog.conf') }
    it { is_expected.to contain_rsyslog__generate_concat('rsyslog::concat::property_filter::mypropertyfilter') }
  end

  context 'with bad operator' do
    let(:params) do
      {
        priority: 55,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        property: 'msg',
        operator: 'equals',
        value: 'val',
        tasks: {
          action: {
            name: 'myaction',
            type: 'omfile',
            config: {
              dynaFile: 'remoteSyslog'
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{\s*Rsyslog::Component::Property_filter\[mypropertyfilter\]: parameter 'operator' expects a match for Rsyslog::PropertyOperator\s*}) }
  end

  context 'with valid operators' do
    operators = %w[contains !contains startswith !startswith isequal !isequal regex !regex ereregex !ereregex]
    operators.each do |operator|
      let(:params) do
        {
          priority: 55,
          target: '50_rsyslog.conf',
          confdir: '/etc/rsyslog.d',
          property: 'msg',
          operator: operator,
          value: 'val',
          tasks: {
            action: {
              name: 'myaction',
              type: 'omfile',
              config: {
                dynaFile: 'remoteSyslog'
              }
            }
          }
        }
      end

      it { is_expected.to compile }
    end
  end
end
