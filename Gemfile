source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

gem "bcrypt"
gem "bootsnap", ">= 1.4.4", require: false
gem "config"
gem "jbuilder", "~> 2.7"
gem "kaminari"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "strings-case"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webpacker", "~> 5.0"
gem "faker"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # rspec
  gem "rspec-rails", "~> 4.0.1"
  gem "simplecov-rcov"
  gem "simplecov"

  gem "shoulda-matchers", "~> 5.0"
  gem "factory_bot_rails"

  # rubocop
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false

  # db: mysql2
  gem "mysql2"
  gem "grape_on_rails_routes", "~> 0.3.2"
end

group :development do
  gem "listen", "~> 3.3"
  gem "pry-nav"
  gem "pry-rails"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
  gem "webdrivers"
end

group :production do
  gem "pg"
end

gem "figaro", "~> 1.2"

gem "rails-controller-testing", "~> 1.0"

gem "grape", "~> 1.6"

gem "grape-swagger", "~> 1.4"
gem "grape-swagger-rails", "~> 0.3.1"

gem "rack-cors", "~> 1.1"

gem "jwt", "~> 2.3"

gem "grape-route-helpers", "~> 2.1"
