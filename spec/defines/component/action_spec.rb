require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::action' do
  let(:title) { 'myaction' }

  context 'default action without facility' do
    let(:params) {{
      :type     => 'omelasticsearch',
      :priority => 40,
      :target   => '50_rsyslog.conf',
      :config   => {
        "queue.type"           => "linkedlist",
        "queue.spoolDirectory" => "/var/log/rsyslog/queue",
      }
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::action::myaction').with_content(
        /(?x)# myaction\n
        \s*action\(type="omelasticsearch"\s*\n
        \s+queue\.type="linkedlist"\s*\n
        \s+queue\.spoolDirectory="\/var\/log\/rsyslog\/queue"\s*\n
        \s*\)\s*/)
    end
  end

  context 'facility with single line action' do
    let(:params) {{
      :type     => 'omfile',
      :priority => 40,
      :target   => '50_rsyslog.conf',
      :facility  => 'kern.*',
      :config   => {
        "dynaFile" => "remoteKern",
      }
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::action::myaction').with_content(
        /(?x)# myaction\n
        ^kern\.\*\s*action\(type="omfile"\s*dynaFile="remoteKern"\s*\)\s*/)
    end
  end

  context 'facility with multiline action' do
    let(:params) {{
      :type     => 'omelasticsearch',
      :priority => 40,
      :target   => '50_rsyslog.conf',
      :facility => '*.*',
      :config   => {
        "template"                => "plain-syslog",
        "searchIndex"             => "logstash-index",
        "queue.type"              => "linkedlist",
        "queue.spoolDirectory"    => "/var/log/rsyslog/queue",
        "queue.filename"          => "dbq",
        "queue.maxdiskspace"      => "100g",
        "queue.maxfilesize"       => "100m",
        "queue.SaveOnShutdown"    => "on",
        "server"                  => "logstash.domain.local",
        "action.resumeretrycount" => "-1",
        "bulkmode"                => "on",
        "dynSearchIndex"          => "on"
      }
    }}

    it do
      is_expected.to contain_concat__fragment('rsyslog::component::action::myaction').with_content(
        /(?x)# myaction\n
        ^\*\.\*
        \s*action\(type="omelasticsearch"\s*\n
        \s+template="plain-syslog"\s*\n
        \s+searchIndex="logstash-index"\s*\n
        \s+queue.type="linkedlist"\s*\n
        \s+queue.spoolDirectory="\/var\/log\/rsyslog\/queue"\s*\n
        \s+queue.filename="dbq"\s*\n
        \s+queue.maxdiskspace="100g"\s*\n
        \s+queue.maxfilesize="100m"\s*\n
        \s+queue.SaveOnShutdown="on"\s*\n
        \s+server="logstash.domain.local"\s*\n
        \s+action.resumeretrycount="-1"\s*\n
        \s+bulkmode="on"\s*\n
        \s+dynSearchIndex="on"\s*\n
        \s+\)\s*$\n/)
    end
  end

end

