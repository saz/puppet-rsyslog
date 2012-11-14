require 'spec_helper'

describe 'rsyslog', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-basic' }

      it 'should compile' do
        should contain_class('rsyslog::install')
        should contain_class('rsyslog::config')
        should contain_class('rsyslog::service')
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
        should contain_class('rsyslog::install')
        should contain_class('rsyslog::config')
        should contain_class('rsyslog::service')
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
      let(:title) { 'rsyslog-basic' }

      it 'should compile' do
        should contain_class('rsyslog::install')
        should contain_class('rsyslog::config')
        should contain_class('rsyslog::service')
      end
    end
  end
end
