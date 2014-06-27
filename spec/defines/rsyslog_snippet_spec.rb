require 'spec_helper'

describe 'rsyslog::snippet', :type => :define do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Redhat',
        :operatingsystemmajrelease => 6,
      }
    end

    let (:params) {
      {
        'content' => 'Random Content',
      }
    }

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-snippet-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
      end
    end
  end

  context "osfamily = Debian" do
    let :facts do
      {
        :osfamily        => 'Debian',
      }
    end

    let (:params) {
      {
        'content' => 'Random Content',
      }
    }

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-snippet-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
      end
    end
  end

  context "osfamily = FreeBSD" do
    let :facts do
      {
        :osfamily        => 'freebsd',
      }
    end

    let (:params) {
      {
        'content' => 'Random Content',
      }
    }

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-snippet-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
      end
    end
  end
end
