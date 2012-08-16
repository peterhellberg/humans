# encoding: utf-8

require 'json'

class HumansApp < Sinatra::Base
  set :public_folder => "public", :static => true

  configure :production, :development do
    uri     = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
    ::REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  get "/" do
    erb :index
  end

  get "/:host" do
    content_type :json

    RedisCache.get("humans:#{params[:host]}") {
      JSON.dump HumansTxt.download_and_parse(params[:host], params[:use_ssl])
    }
  end
end
