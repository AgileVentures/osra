Cucumber Features
=================

Configuration
=============
All custom configuration for cucumber is stored in
```
features/support/env_local.rb
```
This is because the safety of anything stored in env.rb
cannot be guaranteed. This file is controlled by cucumber
and can be changed during upgrades.

Javascript
==========
Capybara's standard webdriver does not support javascript.
In order to interact with javascript (such as confirmation
of a delete dialog box) you need to use a different driver.

The drivers we currently support are
- capybara-webkit
- poltergeist (phantomjs)

## Poltergeist
Poltergeist is the default driver and can be triggered in your
tests by putting the annotation @javascript on the line above
your scenario.
Phantomjs automatically accepts a javascript dialog so you can
only test the "happy path". If you want to test alternative paths
you will need to use an alternative driver.

## Webkit
Webkit is another javascript driver that can be used. You can
trigger it in your tests by putting the annotation @webkit on
the line above your scenario.
Because you can test any of the javascript paths you need to
wrap the block of code you are implementing with a call to the
outcome you want. See the following examples.
### Testing accepting the javascript popup
```
page.accept_confirm do
  click_on "Delete"
end
```
### Testing denying the javascript popup
```
page.accept_confirm do
  click_on "Delete"
end
```
### Further Information
You can find out further information on the method calls available
to you at the following [link.](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Session)

## Checking which driver is being used
You can check in your code which driver is being currently used such as:
```
if Capybara.current_driver == :webkit
if Capybara.current_driver == :poltergeist
```
