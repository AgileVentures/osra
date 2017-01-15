source "https://rubygems.org"

ruby "2.2.0"

gem "rails", "~> 4.2.7"

gem "pg" # Ruby interface to PostgreSQL
gem "sass-rails" # use SASS instead of CSS
gem "bootstrap-sass" # sass powered version of bootstrap
gem "bootstrap-datepicker-rails" # bootstrap datepicker
gem "autoprefixer-rails" # auto add vendor prefixes to CSS rules
gem "coffee-rails" # use Coffeescript
gem "uglifier" # compressor for JavaScript assets
gem "sequenced" # sequential IDs in Models
gem "devise" # authentication solution
gem "jquery-rails" # use jquery with Rails
gem "paperclip" # upload attachment files
gem "aws-sdk" # Amazon Web Services - S3 bucket for Paperclip;
gem "coveralls", require: false # measure test coverage
gem "country_select" # country drop-down
gem "roo" # access contents of spreadsheet files
gem "roo-xls" # extend roo to handle legacy xls files
gem "config" # TODO: consider removing after importer settings refactored
gem "newrelic_rpm" # application monitoring on Heroku
gem "haml" # [view] templating engine
gem "will_paginate" # pagination gem for rails branch
gem "will_paginate-bootstrap" # bootstrap integration with will_paginate

group :test do
  gem "capybara" # interact with pages in tests
  gem "shoulda-matchers" # one-line tests for common Rails validations
end

group :development, :test do
  gem "rspec-rails" # RSpec test framework for Rails
  gem "factory-helper" # easily generate fake data
  gem "factory_girl_rails" # use factories to produce objects
  gem "awesome_print" # Well Formatted output in console
  gem "pry-byebug" # a version of pry and debugger compatible with Ruby >2.0.0
  gem "hirb" # formats ActiveRecord objects into table format in the console
  gem "pry-rails" # integrate pry with rails console
  gem "better_errors" # nice output of rails errors in browser
  gem "binding_of_caller" # online console and debugging in browser
  gem "launchy" # open capybara-generated pages in browser
end

group :development do
  gem "web-console" # debugging tools for Rails
end

group :production do
  gem "rails_12factor" # required to run the app on Heroku
  gem "passenger" # web server
end
