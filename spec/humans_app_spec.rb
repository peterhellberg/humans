require_relative "spec_helper"
require_relative "../humans_app.rb"

def app
  HumansApp
end

describe HumansApp do
  it "has a tagline" do
    get '/'
    last_response.body.must_include 'Parsing your'
    last_response.body.must_include 'into JSON'
  end

  it "returns a pretty JSON" do
    REDIS.stub(:exists, false) {
      HumansTxt.stub(:download_and_parse, { foo: 'bar' }) {
        get '/foo?pretty=true'
        last_response.body.must_equal "{\n  \"foo\": \"bar\"\n}"
      }
    }
  end

  it "returns a single line JSON by default" do
    REDIS.stub(:exists, false) {
      HumansTxt.stub(:download_and_parse, { foo: 'bar' }) {
        get '/foo'
        last_response.body.must_equal "{\"foo\":\"bar\"}"
      }
    }
  end
end
