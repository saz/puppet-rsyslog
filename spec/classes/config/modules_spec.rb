require 'spec_helper'

describe 'rsyslog' do
  let (:params) {{
    :modules => ['imuxsock', 'imklog'],
    :module_load_priority => 20,
  }}

  describe 'rsyslog::config::modules' do
    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('rsyslog::config::modules') }
      it { is_expected.to contain_concat__fragment('rsyslog::config::modules').with(
        'target' => '/etc/rsyslog.d/50_rsyslog.conf',
        'order'  => 20
      )}


      it { is_expected.to contain_concat__fragment('rsyslog::config::modules').with_content(
          /(?x)module\(load="imuxsock"\)\n
          module\(load="imklog"\)\s*
          $/
        )
      }
    end
  end
end
