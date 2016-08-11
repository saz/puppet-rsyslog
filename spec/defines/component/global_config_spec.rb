require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::global_config', :include_rsyslog => true do
  let(:title) { 'configoption' }

  context 'when configuring a legacy type value' do
    let(:params) { {
      :type     => "legacy",
      :value    => "on",
      :priority => 40,
      :target   => '50_rsyslog.conf',

    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::global_config::configoption').with_content(
        /(?x)\$configoption\s+on\s*\n/)
    end
  end

end

