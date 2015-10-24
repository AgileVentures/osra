# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Osra::Application.load_tasks

namespace :cucumber do
    desc 'run all aa features'
    task :aa do
      sh 'cucumber -P -v -r features/aa -r features/support features/aa'
    end
end

namespace :spec do
    desc 'run all aa specs'
    task :aa do
      sh 'rspec --exclude-pattern spec/\*\*/hq{,/\*/\*\*}/\*_spec.rb'
    end

    desc 'run all hq specs'
    task :hq do
      sh "rspec --pattern 'spec/\*\*/hq{,/\*/\*\*}/\*_spec.rb,spec/models{,/\*/\*\*}/\*_spec.rb'"
    end
end

desc 'run all rspec and cucumber tests for "aa" and "hq"'
task :default => [:spec, 'cucumber:aa']

namespace :test do
  desc 'run all rspec and cucumber tests for "aa"'
  task :aa => ['spec:aa', 'cucumber:aa']

  desc 'run all rspec tests for "hq"'
  task :hq => ['spec:hq']
end
