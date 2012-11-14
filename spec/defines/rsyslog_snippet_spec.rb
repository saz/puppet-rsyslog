require 'spec_helper'

describe 'rsyslog::snippet', :type => :define do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
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
        should contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("Random Content\n")
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
        should contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("Random Content\n")
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
        should contain_file('/etc/syslog.d/rsyslog-snippet-basic.conf').with_content("Random Content\n")
      end
    end
  end
end
