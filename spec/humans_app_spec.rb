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
    HumansTxt.stub(:download_and_parse, { foo: 'bar' }) do
      get '/foo'
      last_response.body.must_equal "{\n  \"foo\": \"bar\"\n}"
    end
  end
end
