require 'spec_helper'

describe 'rsyslog::config', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.conf')
        should contain_file('/etc/rsyslog.d/')
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
      let(:title) { 'rsyslog-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.conf')
        should contain_file('/etc/rsyslog.d/')
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
      let(:title) { 'rsyslog-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.conf')
        should contain_file('/etc/syslog.d/')
      end
    end
  end
end
