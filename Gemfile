source "https://rubygems.org"

ruby "2.2.0"

gem "rails", "~> 4.2.7"

gem "autoprefixer-rails" # auto add vendor prefixes to CSS rules
gem "aws-sdk" # Amazon Web Services - S3 bucket for Paperclip;
gem "bootstrap-datepicker-rails" # bootstrap datepicker
gem "bootstrap-sass" # sass powered version of bootstrap
gem "coffee-rails" # use Coffeescript
gem "config" # TODO: consider removing after importer settings refactored
gem "country_select" # country drop-down
gem "coveralls", require: false # measure test coverage
gem "devise" # authentication solution
gem "haml" # [view] templating engine
gem "jquery-rails" # use jquery with Rails
gem "newrelic_rpm" # application monitoring on Heroku
gem "paperclip" # upload attachment files
gem "pg" # Ruby interface to PostgreSQL
gem "roo" # access contents of spreadsheet files
gem "roo-xls" # extend roo to handle legacy xls files
gem "sass-rails" # use SASS instead of CSS
gem "sequenced" # sequential IDs in Models
gem "uglifier" # compressor for JavaScript assets
gem "will_paginate" # pagination gem for rails branch
gem "will_paginate-bootstrap" # bootstrap integration with will_paginate

group :test do
  gem "capybara" # interact with pages in tests
  gem "shoulda-matchers" # one-line tests for common Rails validations
end

group :development, :test do
  gem "awesome_print" # Well Formatted output in console
  gem "better_errors" # nice output of rails errors in browser
  gem "binding_of_caller" # online console and debugging in browser
  gem "factory-helper" # easily generate fake data
  gem "factory_girl_rails" # use factories to produce objects
  gem "hirb" # formats ActiveRecord objects into table format in the console
  gem "launchy" # open capybara-generated pages in browser
  gem "pry-byebug" # a version of pry and debugger compatible with Ruby >2.0.0
  gem "pry-rails" # integrate pry with rails console
  gem "rspec-rails" # RSpec test framework for Rails
end

group :development do
  gem "web-console" # debugging tools for Rails
end

group :production do
  gem "rails_12factor" # required to run the app on Heroku
  gem "passenger" # web server
end
