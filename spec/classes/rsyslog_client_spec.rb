# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog::client', type: :class do
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
      client_conf = "#{rsyslog_d}/00_client.conf"

      context 'default usage' do
        let(:title) { 'rsyslog-client-basic' }

        it 'compiles' do
          is_expected.to contain_file(client_conf)
        end
      end

      context 'split_config => true' do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) { { split_config: true } }

        it 'does not manage 00_client.conf' do
          is_expected.not_to contain_file(client_conf)
        end

        it 'configures client' do
          is_expected.to contain_file("#{rsyslog_d}/00_client_config.conf").with_ensure('present')
        end

        it 'configures client remote logging' do
          is_expected.to contain_file("#{rsyslog_d}/50_client_remote.conf").with_ensure('present')
        end

        it 'removes client local logging' do
          is_expected.to contain_file("#{rsyslog_d}/99_client_local.conf").with_ensure('absent')
        end
      end

      context 'log_filters' do
        let(:title) { 'log_filters_check' }
        let(:params) { { 'log_filters' => [{ 'expression' => '$msg contains \'error0\'', 'action' => '/var/log/err.log' }] } }

        it 'compiles' do
          is_expected.to contain_file(client_conf).with_content(%r{if \$msg contains 'error0' then /var/log/err.log})
        end
      end

      context 'auth_mode' do
        let(:title) { 'rsyslog-client-auth_mode' }

        context 'without SSL' do
          let(:params) { { ssl_auth_mode: 'x509/name' } }

          it 'fails' do
            expect { is_expected.to contain_class('rsyslog::client') }.to raise_error(Puppet::Error, %r{You need to enable SSL in order to use ssl_auth_mode.})
          end
        end

        context 'with SSL' do
          ssl_params = { ssl: true,
                         ssl_ca: '/tmp/cert.pem' }

          context 'with default auth_mode' do
            let(:params) { ssl_params }

            it 'compiles' do
              is_expected.to contain_file("#{rsyslog_d}/00_client.conf").with_content(%r{\$ActionSendStreamDriverAuthMode anon}).without_content(%r{\$ActionSendStreamDriverPermittedPeer})
            end
          end

          context 'without permitted peer' do
            let(:params) do
              ssl_params.merge(
                ssl_auth_mode: 'x509/name'
              )
            end

            it 'contains ActionSendStreamDriverAuthMode' do
              is_expected.to contain_file("#{rsyslog_d}/00_client.conf").with_content(%r{\$ActionSendStreamDriverAuthMode x509/name}).without_content(%r{\$ActionSendStreamDriverPermittedPeer})
            end
          end

          context 'permitted peer with anon auth_mode' do
            let(:params) do
              ssl_params.merge(
                ssl_permitted_peer: 'logs.example.com'
              )
            end

            it 'fails' do
              expect { is_expected.to contain_class('rsyslog::client') }.to raise_error(Puppet::Error, %r{You need to set auth_mode to 'x509/name' in order to use ssl_permitted_peer.})
            end
          end

          context 'with permitted peer' do
            let(:params) do
              ssl_params.merge(
                ssl_auth_mode: 'x509/name',
                ssl_permitted_peer: 'logs.example.com'
              )
            end

            it 'contains ActionSendStreamDriverPermittedPeer' do
              is_expected.to contain_file("#{rsyslog_d}/00_client.conf").with_content(%r{\$ActionSendStreamDriverAuthMode x509/name}).with_content(%r{\$ActionSendStreamDriverPermittedPeer logs.example.com})
            end
          end

          context 'ssl_cert but not ssl_key' do
            let(:params) do
              ssl_params.merge(
                ssl_cert: '/tmp/cert.crt'
              )
            end

            it 'fails' do
              expect { is_expected.to contain_class('rsyslog::client') }.to raise_error(Puppet::Error, %r{If using client side certificates, you must define both the cert and the key.})
            end
          end

          context 'ssl_key but not ssl_cert' do
            let(:params) do
              ssl_params.merge(
                ssl_key: '/tmp/cert.key'
              )
            end

            it 'fails' do
              expect { is_expected.to contain_class('rsyslog::client') }.to raise_error(Puppet::Error, %r{If using client side certificates, you must define both the cert and the key.})
            end
          end

          context 'without SSL client cert and key' do
            it 'does not contain DefaultNetstreamDriverCertFile or DefaultNetstreamDriverKeyFile' do
              is_expected.to contain_file("#{rsyslog_d}/00_client.conf").without_content(%r{\$DefaultNetstreamDriverCertFile}).without_content(%r{\$DefaultNetstreamDriverKeyFile})
            end
          end

          context 'with SSL client cert and key' do
            let(:params) do
              ssl_params.merge(
                ssl_cert: '/tmp/cert.crt',
                ssl_key: '/tmp/cert.key'
              )
            end

            it 'contains DefaultNetstreamDriverCertFile and DefaultNetstreamDriverKeyFile' do
              is_expected.to contain_file("#{rsyslog_d}/00_client.conf").with_content(%r{\$DefaultNetstreamDriverCertFile /tmp/cert.crt}).with_content(%r{\$DefaultNetstreamDriverKeyFile /tmp/cert.key})
            end
          end
        end
      end
    end
  end
end
