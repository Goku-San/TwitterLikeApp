# README for Twitter Like App

This application is based on
*[Ruby on Rails Tutorial: Learn Web Development with Rails](https://www.railstutorial.org/)*
by [Michael Hartl](http://www.michaelhartl.com/)
the *[4th edition tutorial](https://www.learnenough.com/ruby-on-rails-4th-edition-tutorial/)*.

**This is by no means a production application**

## Getting started

* Ruby version that I used for the tutorial ``` 2.6.6 ```.
* Rails version that I used for the tutorial ``` 5.2.4.3 ```.
* Database that I used for the tutorial MariaDB, with ``` gem mysql2, '0.5.3' ```

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install
```

Next, create the database && migrate && seed:

```
$ rails db:create && rails db:migrate && rails db:seed
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in development:
One test fails, because I disabled the activation user accounts, rather commented out the code

```
$ rails server
```
