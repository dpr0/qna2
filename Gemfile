source 'https://rubygems.org'
gem 'rails', '4.2.1'                 # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'                             # Use postgresql as the database for Active Record
gem 'sass-rails', '~> 5.0'           # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0'           # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'       # Use CoffeeScript for .coffee assets and views
gem 'therubyracer', platforms: :ruby # See https://github.com/rails/execjs#readme for more supported runtimes
gem 'jquery-rails'                   # Use jquery as the JavaScript library
gem 'turbolinks'                     # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0'             # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0', group: :doc  # bundle exec rake doc:rails generates the API under doc/api.
gem 'slim-rails'
gem 'devise'
gem 'bootstrap-sass'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'jquery-ui-rails'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'thin'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
gem 'handlebars_assets'
gem 'cancancan' # gem 'pundit'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
#gem 'delayed_job_active_record'
gem 'whenever'
gem 'sidekiq', '~> 3.4.2' 
gem 'sinatra', require: nil
gem 'sidetiq'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'riddle'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'


# gem 'activerecord-postgres-hstore'
# gem 'bcrypt', '~> 3.1.7'           # Use ActiveModel has_secure_password
# gem 'unicorn'                      # Use Unicorn as the app server
group :development do                # Use Capistrano for deployment
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false

end

group :development, :test do
  gem 'byebug'                       # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'web-console', '~> 2.0'        # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                       # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rubocop'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry'
  gem 'better_errors'
# gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'capybara-webkit'
end
group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'json_spec'
  gem 'email_spec'
end
