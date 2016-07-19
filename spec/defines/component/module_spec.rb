require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::module' do
  let(:title) { 'impstats' }

  context 'string action' do
    let(:params) { {
      :type     => 'external',
      :priority => 20,
      :target   => '50_rsyslog.conf',
      :config   => {
        "interval"    => "60",
        "severity"    => "7",
        "log.syslog"  => "off",
        "log.file"    => "/var/log/rsyslog/logs/stats/stats.log",
        "Ruleset"     => "remote",
      }
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::module::impstats').with_content(
        /(?x)module\s*\(\s*load="impstats"\s*\n
        \s+interval="60"\n
        \s+severity="7"\n
        \s+log.syslog="off"\n
        \s+log.file="\/var\/log\/rsyslog\/logs\/stats\/stats.log"\n
        \s+Ruleset="remote"\n
        \s+\n
        \)\n$/)
    end

    it do 
      is_expected.to contain_concat__fragment('rsyslog::component::module::impstats').with(
        'target' => '/etc/rsyslog.d/50_rsyslog.conf',
        'order'  => 20
      )
    end

  end
end
