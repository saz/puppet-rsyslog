require 'spec_helper'

describe 'rsyslog::server', :type => :class do

  ['RedHat', 'Debian'].each do |osfamily|
    context "osfamily = #{osfamily}" do
      let :facts do
        {
          :osfamily        => osfamily,
        }
      end

      context "default usage (osfamily = #{osfamily})" do
        let(:title) { 'rsyslog-server-basic' }

        it 'should compile' do
          should contain_file('/etc/rsyslog.d/server.conf')
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

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-server-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.d/server.conf')
      end
    end
  end

end # describe 'rsyslog::server'
