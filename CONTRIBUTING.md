Contributing
====

### Briefly:
1. Fork the repo and clone it to your local development environment.
2. Create a feature branch off `develop`.
3. Use BDD & TDD to develop your feature. Please follow the style conventions you see in our code base.
4. Push the feature branch up to your fork and submit a pull request to our `develop`.

### To make a stronger contribution:
As described in `README.md`, we follow Agile methods and work closely with our client to prioritize our objectives. While we welcome any contribution to the project, you can make a much stronger impact by taking on a high-priority task. To find out more, please consider joining [Agile Ventures](http://www.agileventures.org/) and coming to one of our scrums to familiarize yourself with the project's status and process. We welcome web developers and web designers of all experience levels.

Hope to see you soon!

### Set up your development environment with Cloud9 ( https://c9.io/ )

Start by forking this repository, then create a new project in the Cloud9 dashboard. Select "Clone from URL",
paste in the git URL `https://github.com/YOUR_USERNAME/osra.git` and click "Create".

Go into the IDE (click the button "Start Editing"). First, change the Ruby vesion with this
command:

`$ rvm install ruby-2.2.0`

Now you need to install the capybara-webkit gem

`$ sudo apt-get update`

Install these package needed by capybara-webkit to work correctly

```
$ sudo apt-get install qt5-default libqt5webkit5-dev
$ gem install capybara-webkit -v '1.4.1'
```

Run Bundler to install gems:

`$ bundle install`

Now you have to setup the database and permissions. Start the postgres server

`$ sudo service postgresql start`

and enter the postgres console

`$ sudo sudo -u postgres psql`

to create a new database user

`postgres=# CREATE USER username SUPERUSER PASSWORD 'password';`

Quit the console with

`postgres=# \q`

Setup the environment variables in Cloud9 to hold the db user credentials:

```
$ echo "export USERNAME=username" >> ~/.profile
$ echo "export PASSWORD=password" >> ~/.profile
$ source ~/.profile
```

In config/database.yml, change the username, password and host for all environments:

```
  .
  .
  username: <%= ENV['USERNAME'] %>
  password: <%= ENV['PASSWORD'] %>
  host: <%= ENV['IP'] %>
```

Then head back to the postgres console:

`$ sudo sudo -u postgres psql`

and enter these commands:

```
postgres=# UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
postgres=# DROP DATABASE template1;
postgres=# CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
postgres=# UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
postgres=# \c template1
postgres=# VACUUM FREEZE;
postgres=# \q
```

The db user authentication should now proceed without issue and you can continue the
setup:

```
$ bundle exec rake db:setup
$ bundle exec rake db:test:prepare
```

The next step is to install PhantomJS. Begin by running

```
$ sudo apt-get update
$ sudo apt-get install build-essential chrpath libssl-dev libxft-dev
```

Install these packages needed by PhantomJS to work correctly

```
$ sudo apt-get install libfreetype6 libfreetype6-dev
$ sudo apt-get install libfontconfig1 libfontconfig1-dev
```

Finally, install PhantomJS itself:

```
$ cd ~
$ export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
$ wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
$ sudo tar xvjf $PHANTOM_JS.tar.bz2
$ sudo mv $PHANTOM_JS /usr/local/share
$ sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
```

PhantomJS should now be properly installed in your Cloud9 environment. Check
that this is so by running

`$ phantomjs --version`

You are nearly finished. It's time to run the test suite:

```
$ cd workspace
$ rake
```

All tests should be passing.

You can now start the server:

`$ rails s -p $PORT -b $IP`

Your Cloud9 environment should now be fully set up to work on OSRA. If you run
into any problems during this process, please reach out to the OSRA team on
Slack or, if you don't have access to that yet, by creating a GitHub issue.

We look forward to having you on our team!
