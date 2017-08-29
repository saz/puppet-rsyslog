require 'spec_helper'


describe 'rsyslog::component::main_queue', :include_rsyslog => true do
  let(:title) { 'main_queue_opts' }

  let (:params) {{
      :priority => 40,
      :target   => '50_rsyslog.conf',
      :confdir  => '/etc/rsyslog.d',
      :config   =>  {
         "queue.maxdiskspace"    => "1000G",
         "queue.dequeuebatchsize" => "1000",
      }
  }}

  describe 'rsyslog::component::main_queue::main_queue_opts' do
    context 'with defaults for all parameters' do

      it do is_expected.to contain_concat__fragment('rsyslog::component::main_queue::main_queue_opts').with(
        'target' => '/etc/rsyslog.d/50_rsyslog.conf',
        'order'  => 40
        )
      end

      it do
        is_expected.to contain_concat__fragment('rsyslog::component::main_queue::main_queue_opts').with_content(
          /(?x)\s*main_queue\s*\(\n
          \s*queue.maxdiskspace="1000G"\s*\n
          \s*queue.dequeuebatchsize="1000"\s*\n
          \s*\)\s*/)
      end
    end
  end

end
