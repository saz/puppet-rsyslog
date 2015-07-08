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

      context "auth_mode (osfamily = Debian)" do

        let(:title) { 'rsyslog-client-auth_mode' }

        context "without SSL" do
          let(:params) { { :ssl_auth_mode => 'x509/name' } }
          it 'should fail' do
            expect { should contain_class('rsyslog::client') }.to raise_error(Puppet::Error, /You need to enable SSL in order to use ssl_auth_mode./)
          end
        end

        context "with SSL" do
          let :pre_condition do
            "class { 'rsyslog': ssl => true }"
          end

          ssl_params = { :ssl_ca => '/tmp/cert.pem' }

          context "with default auth_mode" do
            let(:params) { ssl_params }

            it 'should compile' do
              should contain_file('/etc/rsyslog.d/client.conf').with_content(/\$ActionSendStreamDriverAuthMode anon/).without_content(/\$ActionSendStreamDriverPermittedPeer/)
            end
          end

          context "without permitted peer" do
            let(:params) do
              ssl_params.merge({
                :ssl_auth_mode => 'x509/name',
              })
            end

            it 'should contain ActionSendStreamDriverAuthMode' do
              should contain_file('/etc/rsyslog.d/client.conf').with_content(/\$ActionSendStreamDriverAuthMode x509\/name/).without_content(/\$ActionSendStreamDriverPermittedPeer/)
            end
          end

          context "permitted peer with anon auth_mode" do
            let(:params) do
              ssl_params.merge({
                :ssl_permitted_peer => 'logs.example.com'
              })
            end

            it 'should fail' do
              expect { should contain_class('rsyslog::client') }.to raise_error(Puppet::Error, /You need to set auth_mode to 'x509\/name' in order to use ssl_permitted_peer./)
            end
          end

          context "with permitted peer" do
            let(:params) do
              ssl_params.merge({
                :ssl_auth_mode      => 'x509/name',
                :ssl_permitted_peer => 'logs.example.com'
              })
            end

            it 'should contain ActionSendStreamDriverPermittedPeer' do
              should contain_file('/etc/rsyslog.d/client.conf').with_content(/\$ActionSendStreamDriverAuthMode x509\/name/).with_content(/\$ActionSendStreamDriverPermittedPeer logs.example.com/) 
            end
          end
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
