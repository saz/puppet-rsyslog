# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog', type: :class do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      rsyslog_package = 'rsyslog'
      relp_package = 'rsyslog-relp'
      rsyslog_d = '/etc/rsyslog.d'
      service_name = 'rsyslog'
      rsyslog_conf = '/etc/rsyslog.conf'
      im_journal_ratelimit_burst = nil
      rsyslog_default = '/etc/default/rsyslog'
      spool_dir = '/var/spool/rsyslog'

      case facts[:os]['family']
      when 'FreeBSD'
        rsyslog_package = 'sysutils/rsyslog8'
        relp_package = nil
        rsyslog_d = '/usr/local/etc/rsyslog.d'
        service_name = 'rsyslogd'
        rsyslog_conf = '/usr/local/etc/rsyslog.conf'
        rsyslog_default = '/etc/defaults/syslogd'
      when 'Gentoo'
        rsyslog_package = 'app-admin/rsyslog'
        relp_package = nil
        rsyslog_default = '/etc/conf.d/rsyslog'
      when 'Suse'
        relp_package = nil
        service_name = 'syslog'
        rsyslog_default = '/etc/sysconfig/syslog'
      when 'RedHat'
        rsyslog_default = '/etc/sysconfig/rsyslog'
        spool_dir = '/var/lib/rsyslog'
        case facts[:os]['name']
        when 'Amazon'
          relp_package = nil
        else
          im_journal_ratelimit_burst = 20_000
        end
      end

      context 'default usage' do
        let(:title) { 'rsyslog-basic' }

        it 'compiles' do
          is_expected.to contain_class('rsyslog::install')
          is_expected.to contain_package(rsyslog_package)
          is_expected.to contain_package(relp_package) if relp_package
          is_expected.to contain_file(rsyslog_d).with_ensure('directory').that_requires('Class[rsyslog::install]')
          is_expected.to contain_file(rsyslog_conf).with_ensure('file').that_requires("File[#{rsyslog_d}]")
          is_expected.to contain_service(service_name)
          if im_journal_ratelimit_burst
            is_expected.to contain_file(rsyslog_conf).with_content(%r{\$imjournalRatelimitBurst #{im_journal_ratelimit_burst}})
          else
            is_expected.to contain_file(rsyslog_conf).without_content(%r{\$imjournalRatelimitBurst})
          end
          is_expected.to contain_file(rsyslog_default).with_ensure('file')
          is_expected.to contain_file(spool_dir).with_ensure('directory')
        end
      end

      context 'extra_modules set' do
        let(:title) { 'rsyslog-extra-modules-set' }

        let(:params) { { extra_modules: ['modA'] } }

        it 'compiles' do
          is_expected.to contain_file(rsyslog_conf).with_content(%r{\$ModLoad modA})
        end
      end

      context 'local host name' do
        let(:title) { 'rsyslog-local-hostname' }

        context 'with defaults' do
          it 'is not set' do
            is_expected.to contain_file(rsyslog_conf).without_content(%r{\$LocalHostName})
          end
        end

        context 'when set' do
          let(:params) { { local_host_name: 'example.dev' } }

          it 'compiles' do
            is_expected.to contain_file(rsyslog_conf).with_content(%r{\$LocalHostName example.dev})
          end
        end
      end
    end
  end
end
