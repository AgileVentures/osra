desc 'Regenerate db from scratch and seed'
task :regenerate_db => %w(db:drop db:create db:migrate db:seed)
