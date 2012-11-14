require 'spec_helper'

describe 'rsyslog::install', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-install-basic' }

      it 'should compile' do
        should contain_package('rsyslog')
        should contain_package('rsyslog-relp')
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
      let(:title) { 'rsyslog-install-basic' }

      it 'should compile' do
        should contain_package('rsyslog')
        should contain_package('rsyslog-relp')
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
      let(:title) { 'rsyslog-install-basic' }

      it 'should compile' do
        should contain_package('sysutils/rsyslog5')
        should contain_package('sysutils/rsyslog5-relp')
      end
    end
  end
end
