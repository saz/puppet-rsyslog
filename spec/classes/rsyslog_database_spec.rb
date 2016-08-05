require 'spec_helper'

describe 'rsyslog::database', type: :class do
  context 'Rsyslog version >= 8' do
    let(:default_facts) do
      {
        rsyslog_version: '8.1.2'
      }
    end

    context 'osfamily = RedHat' do
      let :facts do
        default_facts.merge!(
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '6'
        )
      end

      context 'default usage mysql (osfamily = RedHat)' do
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
          should contain_package('rsyslog-mysql')
          should contain_file('/etc/rsyslog.d/mysql.conf')
        end
      end

      context 'default usage pgsql (osfamily = RedHat)' do
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
          should contain_package('rsyslog-pgsql')
          should contain_file('/etc/rsyslog.d/pgsql.conf')
        end
      end
    end

    context 'osfamily = Debian' do
      let :facts do
        default_facts.merge!(
          osfamily: 'Debian',
          operatingsystem: 'Debian'
        )
      end

      context 'default usage mysql (osfamily = Debian)' do
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
          should contain_package('rsyslog-mysql')
          should contain_file('/etc/rsyslog.d/mysql.conf')
        end
      end

      context 'default usage pgsql (osfamily = Debian)' do
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
          should contain_package('rsyslog-pgsql')
          should contain_file('/etc/rsyslog.d/pgsql.conf')
        end
      end
    end
  end

  context 'Rsyslog version =< 8' do
    let(:default_facts) do
      {
        rsyslog_version: '7.1.2'
      }
    end

    context 'osfamily = RedHat' do
      let :facts do
        default_facts.merge!(
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '6'
        )
      end

      context 'default usage mysql (osfamily = RedHat)' do
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
          should contain_package('rsyslog-mysql')
          should contain_file('/etc/rsyslog.d/mysql.conf')
        end
      end

      context 'default usage pgsql (osfamily = RedHat)' do
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
          should contain_package('rsyslog-pgsql')
          should contain_file('/etc/rsyslog.d/pgsql.conf')
        end
      end
    end

    context 'osfamily = Debian' do
      let :facts do
        default_facts.merge!(
          osfamily: 'Debian',
          operatingsystem: 'Debian'
        )
      end

      context 'default usage mysql (osfamily = Debian)' do
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
          should contain_package('rsyslog-mysql')
          should contain_file('/etc/rsyslog.d/mysql.conf')
        end
      end

      context 'default usage pgsql (osfamily = Debian)' do
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
          should contain_package('rsyslog-pgsql')
          should contain_file('/etc/rsyslog.d/pgsql.conf')
        end
      end
    end
  end
end
