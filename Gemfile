source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.1'

gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0' # compressor for JavaScript assets
gem 'activeadmin', github: 'activeadmin'
gem 'sequenced' # Sequential IDs in Models
gem 'jbuilder', '~> 1.2'
gem 'devise' # Authentication solution
gem 'jquery-rails'
gem 'paperclip'

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
  gem 'unicorn'
end


