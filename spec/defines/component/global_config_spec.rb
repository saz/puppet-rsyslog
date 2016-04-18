require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::global_config' do
  let(:title) { 'configoption' }

  context 'when configuring a rainerscript value' do
    let(:params) { {
      :value    => "on",
      :priority => 40,
      :target   => '50_rsyslog.conf',
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::global_config::configoption').with_content(
        /(?x)\s*global\s*\(\n
        \s+configoption="on"\s*\n
        \s*\)\s*/)
    end
  end

end
    

