begin
  require 'database_cleaner'
  require 'database_cleaner/cucumber'

  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Before('@javascript') do
  DatabaseCleaner.strategy = :truncation
end

After('@javascript') do
  DatabaseCleaner.strategy = :transaction
end

Before('@webkit') do
  DatabaseCleaner.strategy = :truncation
end

After('@webkit') do
  DatabaseCleaner.strategy = :transaction
end
