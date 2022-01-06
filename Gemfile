source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.0.2"

gem "bcrypt"
gem "bootsnap", ">= 1.4.4", require: false
gem "config"
gem "devise"
gem "devise-i18n"
gem "faker"
gem "figaro"
gem "jbuilder", "~> 2.7"
gem "kaminari"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "rails-controller-testing"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "strings-case"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "mysql2"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-rcov"
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
  gem "webdrivers"
end

group :production do
  gem "pg"
end
