Contributing
====

### Briefly:
1. Fork the repo and clone it to your local development environment.
2. Create a feature branch off `develop`.
3. Use BDD & TDD to develop your feature. Please follow the style conventions you see in our code base.
4. Push the feature branch up to your fork and submit a pull request to our `develop`.

### Testing commands:
- `$rake` # -> will run all tests: spec(aa and hq), `cucumber:hq` and `cucumber:aa`
- `$rake test:aa` # -> will run all aa tests: `spec:aa`, `cucumber:aa`
- `$rake test:hq` # -> will run all hq tests: `spec:hq`, `cucumber:hq`
- `$rake spec:aa` # -> will run all aa specs: all specs that are not in a 'hq' folder
- `$rake spec:hq` # -> will run all hq specs: all specs that are in a 'hq' folder
- `$rake cucumber:aa` # -> will run all aa cucumber tests: all features from features/aa and will load all .rb files from  features/aa and features/support
- `$rake cucumber:hq` # -> will run all hq cucumber tests: all features from features/hq and will load all .rb files from  features/hq and features/support
- `$cucumber` and `$cucumber -p aa` # -> will run features in 'aa' profile
- `$cucumber -p hq` # -> will run features in 'hq' profile
- `$rspec spec/controllers/hq/users_controller_spec.rb` $ -> will run rspec tests from one file
- `$cucumber -p aa features/aa/aa_features/users.feature` # -> will run one feature file in 'aa' profile
- `$cucumber -p hq features/hq/hq_features/authentication.feature` # -> will run one feature file in 'hq' profile

### To make a stronger contribution:
As described in `README.md`, we follow Agile methods and work closely with our client to prioritize our objectives. While we welcome any contribution to the project, you can make a much stronger impact by taking on a high-priority task. To find out more, please consider joining [Agile Ventures](http://www.agileventures.org/) and coming to one of our scrums to familiarize yourself with the project's status and process. We welcome web developers and web designers of all experience levels.

Hope to see you soon!

