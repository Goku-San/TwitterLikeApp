source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.7'

# Reason --> rails c ==> cannot load such file -- irb (LoadError)
# gem 'irb', '1.2.1'

# Use mysql as the database for Active Record
gem 'mysql2', '0.5.3'

# Use Slim for lightweight Html syntax
gem 'slim', '4.1.0'
gem 'slim-rails', '3.4.0'

# Use Puma as the app server
gem 'puma', '5.6.4'

# Use SCSS/SASS for stylesheets
gem 'sassc-rails', '2.1.2'

# Bootstrap ready to use css framework
gem 'bootstrap', '4.6.1'
gem 'jquery-rails', '4.4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '4.2.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '5.0.0'

# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.2.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '2.9.1'

# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.17'

# Use Devise for authentication
# gem 'devise', '4.7.1'

# Use ActiveStorage variant
gem 'mini_magick', '4.11.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use to easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '2.20.0'

# Ultimate pagination gem that outperforms the others :D
gem 'pagy', '5.6.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '11.1.3', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '3.7.1'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '3.7.0'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring', '4.0.0'
  # gem 'spring-watcher-listen', '2.0.1'

  # For nice coloring output in terminal... ;)
  # gem 'shog', '0.2.1'
end

group :test do
  # This gem brings back -- assigns -- to your controller tests as well as
  # assert_template to both controller and integration tests.
  gem 'rails-controller-testing', '1.0.5'

  # Minitest provides a complete suite of testing facilities supporting
  # TDD, BDD, mocking, and benchmarking.
  gem 'minitest', '5.15.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
