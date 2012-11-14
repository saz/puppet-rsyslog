require 'spec_helper'

describe 'rsyslog::service', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-service-basic' }

      it 'should compile' do
        should contain_service('rsyslog')
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
      let(:title) { 'rsyslog-service-basic' }

      it 'should compile' do
        should contain_service('rsyslog')
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
      let(:title) { 'rsyslog-service-basic' }

      it 'should compile' do
        should contain_service('syslogd')
      end
    end
  end
end
