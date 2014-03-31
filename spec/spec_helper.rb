# encoding: utf-8

# require spec support files and shared behavior
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
  config.include ExecutorDouble

  config.expect_with :rspec do |c|
    # Allow both for now
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    # Allow both for now
    c.syntax = [:should, :expect]
  end
end
