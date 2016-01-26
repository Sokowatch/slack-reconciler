#!/usr/bin/env rake

desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--color)
  t.verbose = false
end

task default: :spec
