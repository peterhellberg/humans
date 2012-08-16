require_relative "spec_helper"
require_relative "../humans_app.rb"

def app
  HumansApp
end

describe HumansApp do
  it "has a tagline" do
    get '/'
    last_response.body.must_include 'Parsing your humans.txt into JSON'
  end
end
