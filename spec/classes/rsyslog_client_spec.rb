require 'spec_helper'

describe 'rsyslog::client', :type => :class do

  context "Rsyslog version >= 8" do
    let(:default_facts) do
      {
        :rsyslog_version => '8.1.2'
      }
    end

    context "osfamily = RedHat" do
      let :facts do
        default_facts.merge!({
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemmajrelease => '6',
        })
      end

      context "default usage (osfamily = RedHat)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/rsyslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/rsyslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/rsyslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/rsyslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end

    context "osfamily = Debian" do
      let :facts do
        default_facts.merge!({
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        })
      end

      context "default usage (osfamily = Debian)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/rsyslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/rsyslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/rsyslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/rsyslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end

    context "osfamily = FreeBSD" do
      let :facts do
        default_facts.merge!({
          :osfamily        => 'FreeBSD',
          :operatingsystem => 'FreeBSD',
        })
      end

      context "default usage (osfamily = FreeBSD)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/syslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/syslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/syslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/syslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/syslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end
  end

  context "Rsyslog version =< 8" do
    let(:default_facts) do
      {
        :rsyslog_version => '7.1.2'
      }
    end

    context "osfamily = RedHat" do
      let :facts do
        default_facts.merge!({
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemmajrelease => '6',
        })
      end

      context "default usage (osfamily = RedHat)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/rsyslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/rsyslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/rsyslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/rsyslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end

    context "osfamily = Debian" do
      let :facts do
        default_facts.merge!({
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        })
      end

      context "default usage (osfamily = Debian)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/rsyslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/rsyslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/rsyslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/rsyslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end

    context "osfamily = FreeBSD" do
      let :facts do
        default_facts.merge!({
          :osfamily        => 'FreeBSD',
          :operatingsystem => 'FreeBSD',
        })
      end

      context "default usage (osfamily = FreeBSD)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/syslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/syslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/syslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/syslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/syslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end
  end

  context "Rsyslog version = nil" do
    let(:default_facts) do
      {
        :rsyslog_version => nil
      }
    end

    context "osfamily = RedHat" do
      let :facts do
        default_facts.merge!({
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemmajrelease => '6',
        })
      end

      context "default usage (osfamily = RedHat)" do
        let(:title) { 'rsyslog-client-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/client.conf')
        end
      end

      context "split_config => true" do
        let(:title) { 'rsyslog-client-basic' }
        let(:params) {{ :split_config => true }}

        it 'should not manage client.conf' do
          should_not contain_file('/etc/rsyslog.d/client.conf')
        end

        it 'should configure client' do
          should contain_file('/etc/rsyslog.d/00_client_config.conf').with_ensure('present')
        end

        it 'should configure client remote logging' do
          should contain_file('/etc/rsyslog.d/50_client_remote.conf').with_ensure('present')
        end

        it 'should remove client local logging' do
          should contain_file('/etc/rsyslog.d/99_client_local.conf').with_ensure('absent')
        end
      end
    end
  end
end
