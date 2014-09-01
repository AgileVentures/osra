source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.1'

gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0' # compressor for JavaScript assets
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'sequenced' # Sequential IDs in Models
gem 'jbuilder', '~> 1.2'
gem "devise" # Authentication solution
gem "jquery-rails"

group :test do
  gem "capybara"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem 'shoulda-matchers', require: false # one-line tests for common Rails validations
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end


