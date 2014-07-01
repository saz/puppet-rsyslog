require 'spec_helper'

describe 'rsyslog::client', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemmajrelease => 6,
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-client-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/client.conf')
      end
    end
  end

  context "osfamily = Debian" do
    let :facts do
      {
        :osfamily        => 'Debian',
      }
    end

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-client-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/client.conf')
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
      let(:title) { 'rsyslog-client-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.d/client.conf')
      end
    end
  end
end
