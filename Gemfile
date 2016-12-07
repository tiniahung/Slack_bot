source 'https://rubygems.org'

gem 'sinatra'
gem 'json'
gem 'shotgun'
gem "rake"
gem 'activerecord'
gem 'sinatra-activerecord' # excellent gem that ports ActiveRecord for Sinatra
gem 'activesupport'

gem 'slack-ruby-client'
gem 'httparty'
gem 'rspotify'

# to avoid installing postgres use 
# bundle install --without production

group :development, :test do
  gem 'sqlite3'
  gem 'dotenv'
  gem 'certified'

end

group :production, :staging do
  gem 'pg'
end

