require 'spec_helper'

describe 'Rsyslog', include_rsyslog: true do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('rsyslog') }
    it { is_expected.to contain_class('rsyslog::base') }
  end

  describe 'Rsyslog::Base' do
    context 'with defaults' do
      it { is_expected.to contain_package('rsyslog').with_ensure('installed') }
      it { is_expected.to contain_file('/etc/rsyslog.d').with_ensure('directory').that_requires('Package[rsyslog]') }
      it { is_expected.to contain_file('/etc/rsyslog.conf').with_ensure('file') }
      it { is_expected.to contain_service('rsyslog').with_ensure('running').with_enable(true) }
    end

    context 'with package not managed' do
      let(:params) { { 'manage_package' => false } }

      it { is_expected.not_to contain_package('rsyslog') }
    end

    context 'with feature packages' do
      let(:params) { { 'feature_packages' => %w[rsyslog-relp rsyslog-mmnormalize rsyslog-gnutls] } }

      it { is_expected.to contain_package('rsyslog-relp').with_ensure('installed') }
      it { is_expected.to contain_package('rsyslog-mmnormalize').with_ensure('installed') }
      it { is_expected.to contain_package('rsyslog-gnutls').with_ensure('installed') }
    end

    context 'with manage_confdir disabled' do
      let(:params) { { 'manage_confdir' => false } }

      it { is_expected.not_to contain_file('/etc/rsyslog.d') }
    end

    context 'with override_default_config disabled' do
      let(:params) { { 'override_default_config' => false } }

      it { is_expected.not_to contain_file('/etc/rsyslog.conf') }
    end

    context 'with service disabled' do
      let(:params) { { 'manage_service' => false } }

      it { is_expected.not_to contain_service('rsyslog') }
    end
  end
end
