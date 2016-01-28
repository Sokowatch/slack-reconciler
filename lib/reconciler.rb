require 'sinatra'
require 'json'
require 'reconciler_notifier'
require 'reconciler_parser'

post '/github' do
  github = ReconcilerParser::Github.new(request.body.read)
  puts "\n\n\n#{github.icon_url}\n"
  notifier = ReconcilerNotifier.new(icon_url: github.icon_url)
  notifier.send_message(github.message) if github.message
  status '200'
  github.message || 'No request body'
end
