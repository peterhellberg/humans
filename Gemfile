source "https://rubygems.org"

ruby "2.0.0"

# Web server
gem "unicorn"

# App Stack
gem "sinatra", "~> 1.4.2"

# Redis
gem "hiredis", "~> 0.4"
gem "redis", "~> 3.0", :require => ["redis/connection/hiredis", "redis"]

group :test do
  gem "fakeredis", "~> 0.4"
end

group :development do
  gem "rake"
  gem "kicker", "3.0.0pre1"
  gem "rb-fsevent", "~> 0.9.1"
  gem "minitest"
  gem "rack-test"
end
