require 'spec_helper'

describe 'rsyslog::snippet', type: :define do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'FreeBSD'
        rsyslog_d = '/usr/local/etc/rsyslog.d/'
      else
        rsyslog_d = '/etc/rsyslog.d/'
      end

      context 'default usage' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'content' => 'Random Content' } }

        it 'compiles' do
          is_expected.to contain_file("#{rsyslog_d}rsyslog-snippet-basic.conf").with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end
  end
end
