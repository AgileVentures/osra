require 'capybara/poltergeist'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'headless'

# use poltergeist (phantomjs) for javascript tests
# others can be :webkit, :selenium
# see features/README.md for more information
Capybara.javascript_driver = :poltergeist

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

headless = Headless.new
headless.start

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = File.join(Rails.root, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures)
end
