require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::lookup_table', include_rsyslog: true do
  let(:title) { 'mylookuptable' }

  context 'default lookup table example' do
    let(:params) do
      {
        priority: 40,
        target: '50_rsyslog.conf',
        confdir: '/etc/rsyslog.d',
        lookup_json: {
          'version' => 1,
          'nomatch' => 'unk',
          'type'    => 'string',
          'table'   => [
            { 'index' => '1.1.1.1', 'value' => 'A' },
            { 'index' => '2.2.2.2', 'value' => 'B' }
          ]
        },
        lookup_file: '/etc/rsyslog.d/example_lookup',
        reload_on_hup: true
      }
    end

    it do
      is_expected.to contain_file('rsyslog::component::lookup_table_json::mylookuptable').with_content(
        File.read('spec/fixtures/test_files/example_lookup.json')
      )
    end

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::lookup_table::mylookuptable').with_content(
        File.read('spec/fixtures/test_files/lookup_table.conf')
      )
    end
  end
end
