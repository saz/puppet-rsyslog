require 'spec_helper_acceptance'

describe 'Rsyslog actions' do
  before(:context) do
    cleanup_helper
  end

  context 'basic action' do
    it 'applies with action' do
      pp = <<-MANIFEST
      class { 'rsyslog::server':
        actions => {
          'elasticsearch' => {
            'type'   => 'elasticsearch',
            'config' => {
              'queue.type'           => 'LinkedList',
              'queue.spoolDirectory' => '/var/log/rsyslog/queue'
            }
          }
        }
      }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/rsyslog.d/50_rsyslog.conf') do
      its(:content) { is_expected.to contain('action\(type="elasticsearch"\n\s*queue\.type="LinkedList"\n\s*queue\.spoolDirectory="/var/log/rsyslog/queue"\n\)') }
    end
  end
end
