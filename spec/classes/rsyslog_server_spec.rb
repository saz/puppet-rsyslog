require 'spec_helper'

describe 'rsyslog::server', :type => :class do

  ['RedHat', 'Debian'].each do |osfamily|
    context "osfamily = #{osfamily}" do
      let :facts do
        {
          :osfamily               => osfamily,
          :operatingsystem        => osfamily,
          :operatingsystemmajrelease => 6,
        }
      end

      context "default usage (osfamily = #{osfamily})" do
        let(:title) { 'rsyslog-server-basic' }
      
        it 'should compile' do
          should contain_file('/etc/rsyslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/auth.log/)
          should contain_file('/etc/rsyslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/messages/)
        end
      end

      context "enable_onefile (osfamily = #{osfamily})" do
        let(:title) { 'rsyslog-server-onefile' }
        let(:params) { {'enable_onefile' => 'true'} }
  
        it 'should compile' do
          should_not contain_file('/etc/rsyslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/auth.log/)
          should contain_file('/etc/rsyslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/messages/)
        end
      end

      context "hostname_template (osfamily = #{osfamily})" do
        let(:title) { 'rsyslog-server-onefile' }
        let(:params) { {'custom_config' => 'rsyslog/server-hostname.conf.erb'} }
  
        it 'should compile' do
          should contain_file('/etc/rsyslog.d/server.conf').with_content(/%hostname%\/auth.log/)
          should contain_file('/etc/rsyslog.d/server.conf').with_content(/%hostname%\/messages/)
        end
      end

    end
  end


  context "osfamily = FreeBSD" do
    let :facts do
      {
        :osfamily        => 'freebsd',
      }
    end

    context "default usage (osfamily = FreeBSD)" do
      let(:title) { 'rsyslog-server-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/auth.log/)
        should contain_file('/etc/syslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/messages/)
      end
    end

    context "enable_onefile (osfamily = FreeBSD)" do
      let(:title) { 'rsyslog-server-onefile' }
      let(:params) { {'enable_onefile' => 'true'} }
 
      it 'should compile' do
        should_not contain_file('/etc/syslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/auth.log/)
        should contain_file('/etc/syslog.d/server.conf').with_content(/\(\[A-Za-z-\]\*\)--end%\/messages/)
      end
    end

    context "hostname_template (osfamily = FreeBSD)" do
      let(:title) { 'rsyslog-server-onefile' }
      let(:params) { {'custom_config' => 'rsyslog/server-hostname.conf.erb'} }
 
      it 'should compile' do
        should contain_file('/etc/syslog.d/server.conf').with_content(/%hostname%\/auth.log/)
        should contain_file('/etc/syslog.d/server.conf').with_content(/%hostname%\/messages/)
      end
    end

  end

end # describe 'rsyslog::server'
