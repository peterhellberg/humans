# encoding: utf-8

require 'json'

class HumansApp < Sinatra::Base
  set :public_folder => "public", :static => true

  configure :production, :development do
    unless defined?(::REDIS)
      uri     = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
      ::REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
  end

  get "/" do
    erb :index
  end

  get "/:host" do
    validate_hostname

    content_type :json

    readthrough_cache do
      d = HumansTxt.download_and_parse(params[:host], params[:use_ssl])
      params[:pretty].to_s == 'true' ? JSON.pretty_generate(d) : JSON.dump(d)
    end
  end

  private

  def readthrough_cache(&block)
    if params.has_key? 'cache_disabled'
      yield
    else
      RedisCache.get("humans:#{params[:host]}", 300) { yield }
    end
  end

  def validate_hostname
    halt if params[:host].to_s.match(/\.(png|jpg|ico)$/)
  end
end
