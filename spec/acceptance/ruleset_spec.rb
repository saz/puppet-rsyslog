require 'spec_helper_acceptance'

describe 'rsyslog::component::ruleset' do
  it 'applies' do
    pp = <<-MANIFEST
      class { 'rsyslog::server':
        rulesets => {
          'ruleset_eth0_514_test' => {
            'parameters' => {
              'queue.size' => '10000',
            },
            'rules' => [
              {
                'property_filter' => {
                  'name'     => 'test_property_filter',
                  'property' => 'msg',
                  'operator' => 'contains',
                  'value'    => 'error',
                  'tasks'    => {
                    'call'     => 'action.ruleset.test',
                    'stop'     => true
                  }
                }
              }
            ]
          }
        }
      }
    MANIFEST

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe file('/etc/rsyslog.d/50_rsyslog.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_readable }
    its(:content) { is_expected.to match(%r{# ruleset_eth0_514_test ruleset\nruleset \(name="ruleset_eth0_514_test"\n\s*queue\.size="10000"\n\) {\n# test_property_filter\n:msg, contains, "error" {\ncall action.ruleset.test\nstop\n\s*}\n\n}})}
  end
end