require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::ruleset', :include_rsyslog => true do
  let(:title) { 'myruleset' }

  context 'single call ruleset' do
    let(:params) { {
        :priority => 65,
        :target   => '50_rsyslog.conf',
        :confdir  => '/etc/rsyslog.d',
        :rules    => [
            'call' => 'action.parse.rawmsg'
        ]
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::ruleset::myruleset').with_content(
        /(?x)\s*ruleset\s*\(name="myruleset"
        \s*\)\s*{
        \s*call\s*action\.parse\.rawmsg
        \s*}$/
      )
    end
  end

  context 'ruleset with variables and call' do
    let(:params) { {
        :priority => 65,
        :target   => '50_rsyslog.conf',
        :confdir  => '/etc/rsyslog.d',
        :rules    => [
            { 'set' => { 'uuid' => '$uuid' } },
            { 'set' => { 'rcv_time' => 'exec_template("s_rcv_time")' } },
            'call' => 'action.parse.r_msg'
        ]
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::ruleset::myruleset').with_content(
        /(?x)\s*ruleset\s*\(name="myruleset"
        \s*\)\s*{
        \s*set\s*\$\.uuid\s*=\s*\$uuid;
        \s*set\s*\$\.rcv_time\s*=\s*exec_template\("s_rcv_time"\);
        \s*call\s*action\.parse\.r_msg
        \s*}$/
      )
    end
  end

  context 'ruleset with parameters and a lookup' do
    let(:params) { {
        :priority   => 65,
        :target     => '50_rsyslog.conf',
        :confdir    => '/etc/rsyslog.d',
        :parameters => {
            'parser'     => 'pmrfc3164.hostname_with_slashes',
            'queue.size' => '10000'
        },
        :rules      => [
            { 'lookup' => { 'var' => 'srv', 'lookup_table' => 'srv-map', 'expr' => '$fromhost-ip'} },
        ]
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::ruleset::myruleset').with_content(
<<-EOS
# myruleset ruleset
ruleset (name="myruleset"
  parser="pmrfc3164.hostname_with_slashes"
  queue.size="10000"
) {
  set $.srv = lookup("srv-map", $fromhost-ip);
}
EOS
      )
    end
  end

  context 'ruleset with actions' do
    let(:params) { {
        :priority   => 65,
        :target     => '50_rsyslog.conf',
        :confdir    => '/etc/rsyslog.d',
        :parameters => {
            'parser'     => 'pmrfc3164.hostname_with_slashes',
            'queue.size' => '10000'
        },
        :stop       => true,
        :rules      => [
            {
              'action' => {
                'name' => 'utf8-fix',
                'type' => 'mmutf8fix'
              }
            },
            {
              'action' => {
                'name' => 'myaction1',
                'type' => 'omfile',
                'facility' => '*.*;auth,authpriv.none',
                'config' => {
                    'dynaFile' => 'remoteSyslog',
                    'specifics' => '/var/log/test'
                }
              }
            },
            {
              'action' => {
                'name' => 'myaction2',
                'type' => 'omfile',
                'config' => {
                    'dynaFile' => 'remoteSyslog',
                    'specifics' => '/var/log/test'
                }
              }
            }
        ],
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::ruleset::myruleset').with_content(
<<-EOF
# myruleset ruleset
ruleset (name="myruleset"
  parser="pmrfc3164.hostname_with_slashes"
  queue.size="10000"
) {
  # utf8-fix action
  action(type="mmutf8fix"
    name="utf8-fix"
  )
  # myaction1 action
*.*;auth,authpriv.none         action(type="omfile" 
                                 name="myaction1"
                                 dynaFile="remoteSyslog"
                                 specifics="/var/log/test"
                               )
  # myaction2 action
  action(type="omfile"
    name="myaction2"
    dynaFile="remoteSyslog"
    specifics="/var/log/test"
  )
  stop
}
EOF
      )
    end
  end

  context 'error test' do
    let(:params) { {
      :priority   => 65,
      :target     => '50_rsyslog.conf',
      :confdir    => '/etc/rsyslog.d',
    }}

    it do
      is_expected.to compile.and_raise_error(/Ruleset MUST have at least one of: action, stop, set, call, or lookup/)
    end
  end
end