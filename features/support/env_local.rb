require 'capybara/poltergeist'
require 'headless'

# use poltergeist (phantomjs) for javascript tests
# others can be :webkit, :selenium
# see features/README.md for more information
Capybara.javascript_driver = :poltergeist

headless = Headless.new
headless.start

