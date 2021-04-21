source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

gem 'passwordless', '~> 0.9'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'kaminari', '>= 1.2.1'
gem 'paper_trail'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.6'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'strong_migrations'
gem 'csv'
gem 'pg_search', '~> 2.3', '>= 2.3.2'
gem 'govuk_notify_rails'
gem 'factory_bot_rails', require: false
gem 'faker', require: false
gem 'jsonb_accessor', '~> 1.0.0'
gem 'pundit', '~> 2.1.0'
gem 'validates_timeliness'
gem 'paranoia', '~> 2.2'
gem 'browser', require: 'browser/browser'
gem 'activerecord-import'
gem 'camden_style_guide', '0.3.0', git: 'https://github.com/wearefuturegov/camden-style-guide.git'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'guard', '~>2.16.2', require: false
  gem 'guard-livereload', '~>2.5.2', require: false
  gem 'rack-livereload'
  gem 'foreman'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara', '>= 2.15'
  # database cleaner is not required, but highly recommended
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdrivers'
  gem 'rails-controller-testing'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'rubocop-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'roo', '~> 2.8'
