require 'spec_helper'

describe 'Rsyslog::Config', include_rsyslog: true do
  it { is_expected.to contain_class('rsyslog::config') }
  classes = %w[modules global legacy main_queue templates actions inputs custom lookup_tables parsers rulesets property_filters expression_filters]
  classes.each do |clas|
    it { is_expected.to contain_class("rsyslog::config::#{clas}") }
  end
end
