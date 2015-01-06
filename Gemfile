source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '~> 4.1.8'

gem 'pg'
gem 'sass-rails', '~> 5.0.0'
# sass powered version of bootstrap https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '~> 3.3.1'
# jquery datepicker and bootstrap-sass gem don't play nicely
gem 'bootstrap-datepicker-rails'
# gem to add browser vendor prefixes automatically. Recommended install for
# bootstrap-sass
gem 'autoprefixer-rails', '~> 4.0.2'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 2.6.0' # compressor for JavaScript assets
gem 'activeadmin', github: 'activeadmin'
gem 'sequenced', '>= 2.0.0' # Sequential IDs in Models
gem 'devise' # Authentication solution
gem 'jquery-rails'
gem 'paperclip', '~> 4.2.1'
gem 'aws-sdk'
gem 'coveralls', require: false
gem 'country_select', github: 'stefanpenner/country_select'
gem 'roo'
gem 'rails_config'
gem 'newrelic_rpm'

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'headless' # gem that allows capybara-webkit to run without calling xvfb directly
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false # one-line tests for common Rails validations
end

group :development, :test do
  gem 'rspec-rails'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'awesome_print' # Well Formatted output in console
  gem 'pry-byebug' # a version of pry and debugger compatible with Ruby >2.0.0
  gem 'hirb' # formats ActiveRecord objects into table format in the console
  gem 'pry-rails' # integrate pry with rails console
  gem 'better_errors' # nice output of rails errors in browser
  gem 'binding_of_caller'  #online console and debugging in browser
  gem 'launchy' # open capybara-generated pages in browser
end

group :production do
  gem 'rails_12factor'
  gem 'passenger'
end
