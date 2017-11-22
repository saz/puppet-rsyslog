require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::parser', include_rsyslog: true do
  let(:title) { 'pmrfc3164.hostname_with_slashes' }

  context 'pmrfc3164 parser' do
    let(:params) do
      {
        type: 'pmrfc3164',
        priority: 45,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        config: {
          'permit.slashesinhostname' => 'on'
        }
      }
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::parser::pmrfc3164.hostname_with_slashes').with_content(
        %r{(?x)# pmrfc3164.hostname_with_slashes\n
        \s*parser\(name="pmrfc3164.hostname_with_slashes"\s*\n
        \s*type="pmrfc3164"\s*\n
        \s*permit.slashesinhostname="on"\s*\n
        \s*\)\s*}
      )
    end
  end
end
