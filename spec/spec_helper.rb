# encoding: utf-8

require 'bundler'

Bundler.setup
Bundler.require

ENV["RACK_ENV"] = "test"

require 'minitest/pride'
require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'

require 'fakeredis'
REDIS = Redis.new

require "find"
Find.find("./lib") { |f| require f if f.match(/\.rb$/) }

class MiniTest::Spec
  include Rack::Test::Methods
end

def s(*args)
  subject.new(*args)
end
