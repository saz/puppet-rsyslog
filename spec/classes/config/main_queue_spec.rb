require 'spec_helper'

describe 'rsyslog::server' do
  let(:title) { 'main_queue' }

  let (:params) {{
      :main_queue_opts      =>  {
         "queue.maxdiskspace"    => "1000G",
         "queue.dequeuebatchsize" => "1000",
      }
  }}

  describe 'rsyslog::config::main_queue' do
    context 'with defaults for all parameters' do

      it { is_expected.to contain_class('rsyslog::config::main_queue') }

      it do is_expected.to contain_concat__fragment('rsyslog::config::main_queue').with(
        'target' => '/etc/rsyslog.d/50_rsyslog.conf',
        'order'  => 40
        )
      end

      it do
        is_expected.to contain_concat__fragment('rsyslog::config::main_queue').with_content(
          /(?x)\s*main_queue\s*\(\n
          \s+queue.maxdiskspace="1000G"\s*\n
          \s+queue.dequeuebatchsize="1000"\s*\n
          \s*\)\s*/)
      end
    end
  end

end
