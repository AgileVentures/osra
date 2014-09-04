require 'capybara/poltergeist'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'headless'

# use poltergeist (phantomjs) for javascript tests
# others can be :webkit, :selenium
Capybara.javascript_driver = :poltergeist

DatabaseCleaner.strategy = :truncation

headless = Headless.new
headless.start

