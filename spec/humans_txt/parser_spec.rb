# encoding: utf-8

require_relative "../spec_helper"

describe HumansTxt::Parser do
  subject { HumansTxt::Parser }

  let(:c7)  { s(IO.read('spec/fixtures/c7.se')).parse }
  let(:tv4) { s(IO.read('spec/fixtures/www.tv4.se')).parse }

  describe "parse" do
    it "parses the teams section" do
      tv4[:team].size.must_equal 11
      c7[:team].size.must_equal 1
    end
  end
end
