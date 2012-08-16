source :rubygems

# Web server
gem "unicorn"

# App Stack
gem "sinatra", "~> 1.3.2"

# Redis
gem "hiredis", "~> 0.4"
gem "redis", "~> 3.0", :require => ["redis/connection/hiredis", "redis"]
gem "fakeredis", "~> 0.4"

group :development do
  gem "rake"
  gem "kicker"
  gem "minitest"
  gem "rack-test"
end
