require 'spec_helper_acceptance'

describe 'Rsyslog' do
  context 'with defaults' do
    before(:context) do
      cleanup_helper
    end

    it 'applies' do
      pp = <<-MANIFEST
      class { 'rsyslog': }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/rsyslog.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_readable }
      its(:content) { is_expected.to contain('\$IncludeConfig /etc/rsyslog\.d/\*\.conf') }
    end

    describe file('/etc/rsyslog.d') do
      it { is_expected.to be_directory }
      it { is_expected.to exist }
    end

    describe package('rsyslog') do
      it { is_expected.to be_installed }
    end

    describe service('rsyslog') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end