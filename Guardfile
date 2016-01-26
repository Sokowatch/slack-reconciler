group :red_green_refactor do
  guard :rspec, failed_mode: :focus, cmd: 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^reconciler.rb$})              { |m| "spec/#{m[1]}_spec.rb" }
  end

  guard :rubocop, all_on_start: false do
    watch(%r{(.+)\.rb$})
  end
end