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

      context 'default usage (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'content' => 'Random Content' } }
        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end

      context 'source provided (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'source' => 'puppet:///files/rsyslog.snippet' } }
        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_source('puppet:///files/rsyslog.snippet')
        end
      end

      context 'content and source provided (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { {
          'content' => 'Random Content',
          'source'  => 'puppet:///files/rsyslog.snippet'
        } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/Can't use 'content' and 'source' at the same time./)
        end
      end

      context 'content and source not provided (osfamily = RedHat)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/No 'content' or 'source' provided./)
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


      context 'default usage (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'content' => 'Random Content' } }
        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end

      context 'source provided (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'source' => 'puppet:///files/rsyslog.snippet' } }
        it 'compiles' do
          is_expected.to contain_file('/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_source('puppet:///files/rsyslog.snippet')
        end
      end

      context 'content and source provided (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { {
          'content' => 'Random Content',
          'source'  => 'puppet:///files/rsyslog.snippet'
        } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/Can't use 'content' and 'source' at the same time./)
        end
      end

      context 'content and source not provided (osfamily = Debian)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/No 'content' or 'source' provided./)
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

      context 'default usage (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'content' => 'Random Content' } }
        it 'compiles' do
          is_expected.to contain_file('/usr/local/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end

      context 'source provided (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'source' => 'puppet:///files/rsyslog.snippet' } }
        it 'compiles' do
          is_expected.to contain_file('/usr/local/etc/rsyslog.d/rsyslog-snippet-basic.conf').with_source('puppet:///files/rsyslog.snippet')
        end
      end

      context 'content and source provided (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { {
          'content' => 'Random Content',
          'source'  => 'puppet:///files/rsyslog.snippet'
        } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/Can't use 'content' and 'source' at the same time./)
        end
      end

      context 'content and source not provided (osfamily = FreeBSD)' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { } }
        it 'compiles' do
          is_expected.to compile.and_raise_error(/No 'content' or 'source' provided./)
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
