
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib/')
require 'reconciler'

run Sinatra::Application
