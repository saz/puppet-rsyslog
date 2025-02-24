# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog::imfile', type: :define do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      rsyslog_d = case facts[:os]['family']
                  when 'FreeBSD'
                    '/usr/local/etc/rsyslog.d'
                  else
                    '/etc/rsyslog.d'
                  end

      context 'default usage' do
        let(:title) { 'rsyslog-imfile-basic' }
        let(:params) { { file_name: '/path/to/logfile', file_tag: 'mytag', file_facility: 'local0' } }

        it 'compiles' do
          is_expected.to contain_file("#{rsyslog_d}/rsyslog-imfile-basic.conf")
        end
      end
    end
  end
end
