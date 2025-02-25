# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog::server', type: :class do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      rsyslog_d = '/etc/rsyslog.d'
      case facts[:os]['family']
      when 'FreeBSD'
        rsyslog_d = '/usr/local/etc/rsyslog.d'
      end
      server_conf = "#{rsyslog_d}/00_server.conf"

      context 'default usage' do
        let(:title) { 'rsyslog-server-basic' }

        it 'compiles' do
          is_expected.to contain_file(server_conf).with_content(%r{\(\[A-Za-z-\]\*\)--end%/auth.log})
          is_expected.to contain_file(server_conf).with_content(%r{\(\[A-Za-z-\]\*\)--end%/messages})
          is_expected.to contain_file(server_conf).with_content(%r{\$UDPServerRun 514})
          is_expected.to contain_file(server_conf).with_content(%r{\$InputTCPServerRun 514})
          is_expected.to contain_file(server_conf).with_content(%r{\$InputRELPServerRun 20514})
        end
      end

      context 'enable_onefile' do
        let(:title) { 'rsyslog-server-onefile' }
        let(:params) { { 'enable_onefile' => true } }

        it 'compiles' do
          is_expected.not_to contain_file(server_conf).with_content(%r{\(\[A-Za-z-\]\*\)--end%/auth.log})
          is_expected.to contain_file(server_conf).with_content(%r{\(\[A-Za-z-\]\*\)--end%/messages})
        end
      end

      context 'hostname_template' do
        let(:title) { 'rsyslog-server-onefile' }
        let(:params) { { 'custom_config' => 'rsyslog/server-hostname.conf.erb' } }

        it 'compiles' do
          is_expected.to contain_file(server_conf).with_content(%r{%hostname%/auth.log})
          is_expected.to contain_file(server_conf).with_content(%r{%hostname%/messages})
        end
      end

      context 'log_filters' do
        let(:title) { 'log_filters_check' }
        let(:params) { { 'log_filters' => [{ 'expression' => '$msg contains \'error0\'', 'action' => '/var/log/err.log' }] } }

        it 'compiles' do
          is_expected.to contain_file(server_conf).with_content(%r{if \$msg contains 'error0' then /var/log/err.log})
        end
      end

      context 'enable_tcp = false' do
        let(:title) { 'tcp-listener-disabled' }
        let(:params) { { 'enable_tcp' => false } }

        it 'compiles' do
          is_expected.to contain_file(server_conf).without_content(%r{\$InputTCPServerRun})
        end
      end

      context 'enable_udp = false' do
        let(:title) { 'udp-listener-disabled' }
        let(:params) { { 'enable_udp' => false } }

        it 'compiles' do
          is_expected.to contain_file(server_conf).without_content(%r{\$UDPServerRun})
        end
      end

      context 'enable_relp = false' do
        let(:title) { 'relp-listener-disabled' }
        let(:params) { { 'enable_relp' => false } }

        it 'compiles' do
          is_expected.to contain_file(server_conf).without_content(%r{\$InputRELPServerRun})
        end
      end
    end
  end
end
