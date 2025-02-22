# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog::database', type: :class do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Suse'
        mysql_package = false
        pgsql_package = false
        rsyslog_d = '/etc/rsyslog.d'
      when 'FreeBSD'
        mysql_package = false
        pgsql_package = false
        rsyslog_d = '/usr/local/etc/rsyslog.d'
      else
        mysql_package = true
        pgsql_package = true
        rsyslog_d = '/etc/rsyslog.d'
      end

      context 'default usage mysql' do
        let(:title) { 'rsyslog-database-mysql' }

        let(:params) do
          {
            'backend'  => 'mysql',
            'server'   => 'localhost',
            'database' => 'rsyslog',
            'username' => 'us3rname',
            'password' => 'passw0rd'
          }
        end

        it 'compiles' do
          is_expected.to contain_package('rsyslog-mysql') if mysql_package
          is_expected.to contain_file("#{rsyslog_d}/mysql.conf")
        end
      end

      context 'default usage pgsql' do
        let(:title) { 'rsyslog-database-pgsql' }

        let(:params) do
          {
            'backend'  => 'pgsql',
            'server'   => 'localhost',
            'database' => 'rsyslog',
            'username' => 'us3rname',
            'password' => 'passw0rd'
          }
        end

        it 'compiles' do
          is_expected.to contain_package('rsyslog-pgsql') if pgsql_package
          is_expected.to contain_file("#{rsyslog_d}/pgsql.conf")
        end
      end
    end
  end
end
