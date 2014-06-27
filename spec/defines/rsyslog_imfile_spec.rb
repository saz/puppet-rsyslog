require 'spec_helper'

describe 'rsyslog::imfile', :type => :define do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemmajrelease => 6,
      }
    end

    let (:params) {
      {
        'file_name'     => 'mylogfile',
        'file_tag'      => 'mytag',
        'file_facility' => 'myfacility',
      }
    }

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'rsyslog-imfile-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/rsyslog-imfile-basic.conf')
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
        'file_name'     => 'mylogfile',
        'file_tag'      => 'mytag',
        'file_facility' => 'myfacility',
      }
    }

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-imfile-basic' }

      it 'should compile' do
        should contain_file('/etc/rsyslog.d/rsyslog-imfile-basic.conf')
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
        'file_name'     => 'mylogfile',
        'file_tag'      => 'mytag',
        'file_facility' => 'myfacility',
      }
    }

    context "default usage (osfamily = Debian)" do
      let(:title) { 'rsyslog-imfile-basic' }

      it 'should compile' do
        should contain_file('/etc/syslog.d/rsyslog-imfile-basic.conf')
      end
    end
  end
end
