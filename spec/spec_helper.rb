# encoding: utf-8

require 'rspec'
require 'rspec/mocks/standalone'

if RUBY_VERSION < '1.9'
  require 'rspec/autorun'
end

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
  config.include ExecutorDouble
end
