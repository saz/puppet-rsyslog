require 'spec_helper'
require 'yaml'

describe 'rsyslog::component::template' do
  let(:title) { 'mytpl' }

  context 'string template' do
    let(:params) { {
      :type     => 'string',
      :priority => 30,
      :string   => '/var/log/rsyslog/logs/%fromhost-ip%/%fromhost-ip%.log'
    }}

    it do
      is_expected.to contain_file('/etc/rsyslog.d/30_mytpl_template.conf').with_content(
        /(?x)\s*template\s*\(name="mytpl"\s*type="string"
        \s+string="\/var\/log\/rsyslog\/logs\/%fromhost-ip%\/%fromhost-ip%.log"\s*\)\s*$/)
    end
  end

  context 'plugin template' do
    let(:params) { {
      :type     => 'plugin',
      :priority => 30,
      :plugin   => 'mystringgen'
    }}

    it do
      is_expected.to contain_file('/etc/rsyslog.d/30_mytpl_template.conf').with_content(
        /(?x)\s*template\s*\(name="mytpl"\s*type="plugin"
        \s+plugin="mystringgen"\s*\)\s*$/)
    end
  end

  context 'subtree template' do
    let(:params) { {
      :type     => 'subtree',
      :priority => 30,
      :subtree   => '$!usr!tpl2'
    }}

    it do
      is_expected.to contain_file('/etc/rsyslog.d/30_mytpl_template.conf').with_content(
        /(?x)\s*template\s*\(name="mytpl"\s*type="subtree"
        \s+subtree="\$!usr!tpl2"\s*\)\s*$/)
    end
  end

  context 'template with options' do
    let(:params) { {
      :type     => 'string',
      :priority => 30,
      :string   => '/var/log/rsyslog/logs/%fromhost-ip%/%fromhost-ip%.log',
      :options  => { 'sql' => 'on' }
    }}

    it do
      is_expected.to contain_file('/etc/rsyslog.d/30_mytpl_template.conf').with_content(
        /(?x)\s*template\s*\(name="mytpl"\s*type="string"
        \s+string="\/var\/log\/rsyslog\/logs\/%fromhost-ip%\/%fromhost-ip%.log"
        \s+option\.sql="on"\s*\)\s*$/)
    end
  end

  context 'list template' do
    let(:params) { {
      :type => 'list',
      :priority => 30,
      :list_descriptions => [
        { 'constant' => { 'value' => '{' } },
        { 'constant' => { 'value' => '\"@timestamp\":\"' } },
        { 'property' => { 'name'  => 'timereported', 'dateformat' => 'rfc3339' } },
        { 'constant' => { 'value' => '\"}' } }
    ] } }

    it do

      is_expected.to contain_file('/etc/rsyslog.d/30_mytpl_template.conf').with_content(
        /(?x)\s*template\s+\(name="mytpl"\s+type="list"\s*\)
        \s*\{
        \s*constant\(\s*value="\{"\s*\)\s*\n
        \s*constant\(\s*value="\\\"@timestamp\\":\\""\s*\)\s*\n
        \s*property\(\s*name="timereported"\s+dateformat="rfc3339"\s*\)\s*\n
        \s*constant\(\s*value="\\"\}"\s*\)\s*$
        /)
    end

  end
end
    

