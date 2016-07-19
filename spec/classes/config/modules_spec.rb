require 'spec_helper'

describe 'rsyslog::server' do
  let (:params) {{
    :modules => { "imuxsock"=>{},}
  }}

  describe 'rsyslog::config::modules' do
    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('rsyslog::config::modules') }

    end
  end
end
