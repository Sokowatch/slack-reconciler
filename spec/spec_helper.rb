if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rack/test'
require 'rspec'
require 'rubocop'
require 'pp'
require 'byebug'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'reconciler'
require 'parser'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
