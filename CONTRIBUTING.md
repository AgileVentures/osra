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

### Set up your development environment with Cloud9 ( https://c9.io/ )

Start by forking this repository then create new project in the Cloud9 dashboard select "Clone from URL" 
and paste in the git URL: https://github.com/YOUR_USERNAME/osra.git and click create!

Go into the ide (click the button "start editing"). First change the ruby vesion with this 
command:

$ rvm install ruby-2.2.0

now you must install capybara-webkit gem

$ sudo apt-get update

install these package needed by Capybara-webkit to work correctly

$ sudo apt-get install qt5-default libqt5webkit5-dev
$ gem install capybara-webkit -v '1.4.1'

now you can go with:

$ bundle install

now you have to setup the database and the permissions,
follow these steps:

$ sudo service postgresql start
$ sudo sudo -u postgres psql

now you are in postgresql console!

postgres=# CREATE USER username SUPERUSER PASSWORD 'password';
postgres=# \q

setup the environment variable in Cloud9

$ echo "export USERNAME=username" >> ~/.profile
$ echo "export PASSWORD=password" >> ~/.profile
$ source ~/.profile

in the config/database.yml file change the username, password and host for all environments:

  username: <%= ENV['USERNAME'] %>
  password: <%= ENV['PASSWORD'] %>
  host: <%= ENV['IP'] %>
  
then head back to postgresql console and follow these steps:

$ sudo sudo -u postgres psql
postgres=# UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
postgres=# DROP DATABASE template1;
postgres=# CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
postgres=# UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
postgres=# \c template1
postgres=# VACUUM FREEZE;
postgres=# \q

now the authentication issue must be solved you can continue with

$ bundle exec rake db:setup
$ bundle exec rake db:test:prepare

now you have to install PhantomJS. Follow these commands!

$ sudo apt-get update
$ sudo apt-get install build-essential chrpath libssl-dev libxft-dev

install these packages needed by PhantomJS to work correctly

$ sudo apt-get install libfreetype6 libfreetype6-dev
$ sudo apt-get install libfontconfig1 libfontconfig1-dev

get the PhamtomJS!

$ cd ~
$ export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
$ wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
$ sudo tar xvjf $PHANTOM_JS.tar.bz2
$ sudo mv $PHANTOM_JS /usr/local/share
$ sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

now, you should have PhantomJS properly installed on your system

$ phantomjs --version

ok nearly finished, now run the tests

$ cd workspace
$ bundle exec rspec spec/
$ bundle exec cucumber

all tests must pass
now you can start the server

$  rails s -p $PORT -b $IP


That should work :)



