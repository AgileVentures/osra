source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '~> 4.2.7'

gem 'pg' # Ruby interface to PostgreSQL
gem 'sass-rails' # use SASS instead of CSS
gem 'bootstrap-sass' # sass powered version of bootstrap
gem 'bootstrap-datepicker-rails' # bootstrap datepicker
gem 'autoprefixer-rails' # auto add vendor prefixes to CSS rules
gem 'coffee-rails' # use Coffeescript
gem 'uglifier' # compressor for JavaScript assets
gem 'sequenced' # sequential IDs in Models
gem 'devise' # authentication solution
gem 'jquery-rails' # use jquery with Rails
gem 'paperclip', '~> 4.2.1' # upload attachment files
gem 'aws-sdk', '< 2.0' # Amazon Web Services - S3 bucket for Paperclip;
# as of 07-04-2015, paperclip is not yet compatible with aws-sdk v2.0
gem 'coveralls', require: false # measure test coverage
gem 'country_select', '~> 2.1.1' # country drop-down
gem 'roo', '~> 1.13.2' # access contents of spreadsheet files
gem 'rails_config', '~> 0.4.2' # TODO: consider removing after importer settings refactored
gem 'newrelic_rpm' # application monitoring on Heroku
gem 'haml'  # [view] templating engine
gem 'will_paginate' # pagination gem for rails branch
gem 'will_paginate-bootstrap' # bootstrap integration with will_paginate

group :test do
  gem 'capybara', '~> 2.4.4' # interact with pages in tests
  gem 'shoulda-matchers', '~> 2.8', require: false # one-line tests for common Rails validations
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5' # RSpec test framework for Rails
  gem 'faker', '~> 1.4.3' # easily generate fake data
  gem 'factory_girl_rails', '~> 4.5.0' # use factories to produce objects
  gem 'awesome_print', '~> 1.6.1' # Well Formatted output in console
  gem 'pry-byebug', '~> 3.0.1' # a version of pry and debugger compatible with Ruby >2.0.0
  gem 'hirb', '~> 0.7.3' # formats ActiveRecord objects into table format in the console
  gem 'pry-rails', '~> 0.3.3' # integrate pry with rails console
  gem 'better_errors', '~> 2.1.1' # nice output of rails errors in browser
  gem 'binding_of_caller', '~> 0.7.2'  # online console and debugging in browser
  gem 'launchy', '~> 2.4.3' # open capybara-generated pages in browser
  gem 'web-console', '~> 2.0.0' # debuggin tools for Rails
end

group :production do
  gem 'rails_12factor', '~> 0.0.3' # required to run the app on Heroku
  gem 'passenger', '~> 4.0.59' # web server
end
