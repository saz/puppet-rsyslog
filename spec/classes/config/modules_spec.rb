require 'spec_helper'

describe 'rsyslog' do
  let (:params) {{
    :modules => ['imuxsock', 'imklog']
  }}

  describe 'rsyslog::config::modules' do
    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('rsyslog::config::modules') }
      it {
        is_expected.to contain_file('/etc/rsyslog.d/10_modules.conf').with_content(
          /(?x)module\(load="imuxsock"\)\n
          module\(load="imklog"\)\s*
          $/
        )
      }
    end
  end
end
