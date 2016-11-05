# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Osra::Application.load_tasks

namespace :spec do
  desc 'run all hq specs'
  task :hq do
    sh "rspec --pattern 'spec/\*\*/hq{,/\*/\*\*}/\*_spec.rb,spec/models{,/\*/\*\*}/\*_spec.rb'"
  end
end

desc 'run all rspec tests'
task :default => [:spec]
