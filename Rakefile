require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Validate manifests, templates, and ruby files"
task :syntax_validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    flags = ENV['FUTURE_PARSER'] == 'yes' ? '--parser future' : ''
    sh "puppet parser validate  --noop #{flags}  #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
  #Validate epp template Checks
  Dir['templates/**/*.epp'].each do |template|
    # Although you can use epp with Puppet < 4 + future parser, the epp
    # subcommand won't be available so we can't actually test these :(
    unless ENV['FUTURE_PARSER'] == "yes"
      sh "puppet epp validate  #{template}"
    end
  end

end

task :default => [:syntax_validate, :lint, :spec]
