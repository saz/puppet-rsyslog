require 'spec_helper'

describe 'rsyslog' do
  let (:params) {{
    :global_config => {
      "LegacyOpt"        => { "value" => "off", "type" => "legacy" },
      "parser.RainerOpt" => { "value" => "on" }
  }}}

  describe 'rsyslog::config::global' do
    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('rsyslog::config::global') }
      it { is_expected.to contain_concat('/etc/rsyslog.d/20_global.conf')}
      it { is_expected.to have_concat__fragment_resource_count(2) }
      it { is_expected.to contain_concat__fragment('rsyslog::global::parser.RainerOpt').with_target(
        '/etc/rsyslog.d/20_global.conf')
      }
      it { is_expected.to contain_concat__fragment('rsyslog::global::LegacyOpt').with_target(
        '/etc/rsyslog.d/20_global.conf')
      }
      it {
        is_expected.to contain_concat__fragment('rsyslog::global::parser.RainerOpt').with_content(
          /(?x)\s*global\s+\(\s*\n
          \s+parser\.RainerOpt="on"\s*\n
          \s*\)\s*$/
        )
      }
      it {
        is_expected.to contain_concat__fragment('rsyslog::global::LegacyOpt').with_content(
          /^\$LegacyOpt off$/
        )
      }
    end
  end
end
