require 'spec_helper'

describe 'rsyslog::snippet', type: :define do
  context 'Rsyslog version >= 8' do
    let(:default_facts) do
      {
        rsyslog_version: '8.1.2'
      }
    end

    context 'osfamily = RedHat' do
      let :facts do
        default_facts.merge!(
          osfamily:                  'RedHat',
          operatingsystem:           'Redhat',
          operatingsystemmajrelease: '6'
        )
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end

        let(:title) { 'rsyslog/snippet/basic' }
        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end

    context 'osfamily = Debian' do
      let :facts do
        default_facts.merge!(
          osfamily:        'Debian',
          operatingsystem: 'Debian'
        )
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end

    context 'osfamily = FreeBSD' do
      let :facts do
        default_facts.merge!(
          osfamily:        'FreeBSD',
          operatingsystem: 'FreeBSD'
        )
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/usr/local/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end
  end

  context 'Rsyslog version =< 8' do
    let(:default_facts) do
      {
        rsyslog_version: '7.1.2'
      }
    end

    context 'osfamily = RedHat' do
      let :facts do
        default_facts.merge!(
          osfamily:                  'RedHat',
          operatingsystem:           'Redhat',
          operatingsystemmajrelease: '6'
        )
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end

    context 'osfamily = Debian' do
      let :facts do
        default_facts.merge!(
          osfamily:        'Debian',
          operatingsystem: 'Debian'
        )
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end

    context 'osfamily = FreeBSD' do
      let :facts do
        default_facts.merge!(osfamily: 'FreeBSD', operatingsystem: 'FreeBSD')
      end

      let(:params) { { 'content' => 'Random Content' } }

      context 'default usage (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file('/usr/local/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end
    end
  end
end
