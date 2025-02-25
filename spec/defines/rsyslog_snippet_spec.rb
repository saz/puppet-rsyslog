# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog::snippet', type: :define do
  let :node do
    'rspec.example.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include rsyslog'
      end

      rsyslog_d = case facts[:os]['family']
                  when 'FreeBSD'
                    '/usr/local/etc/rsyslog.d'
                  else
                    '/etc/rsyslog.d'
                  end

      context 'default usage' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'content' => 'Random Content' } }

        it 'compiles' do
          is_expected.to contain_file("#{rsyslog_d}/rsyslog-snippet-basic.conf").with_content("# This file is managed by Puppet, changes may be overwritten\nRandom Content\n")
        end
      end

      context 'source provided' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) { { 'source' => 'puppet:///files/rsyslog.snippet' } }

        it 'compiles' do
          is_expected.to contain_file("#{rsyslog_d}/rsyslog-snippet-basic.conf").with_source('puppet:///files/rsyslog.snippet')
        end
      end

      context 'content and source provided' do
        let(:title) { 'rsyslog-snippet-basic' }
        let(:params) do
          {
            'source' => 'puppet:///files/rsyslog.snippet',
            'content' => 'Random Content'
          }
        end

        it 'compiles' do
          is_expected.to compile.and_raise_error(%r{Can't set 'content' and 'source' at the same time})
        end
      end

      context 'content and source not provided' do
        let(:title) { 'rsyslog-snippet-basic' }

        it 'compiles' do
          is_expected.to contain_file("#{rsyslog_d}/rsyslog-snippet-basic.conf").with_source(nil).with_content(nil)
        end
      end
    end
  end
end
