# encoding: utf-8

require_relative "spec_helper"

describe HumansTxt do
  subject { HumansTxt }

  let(:humanstxt) { IO.read('spec/fixtures/humanstxt.org') }

  describe "download_and_parse" do
    it "downloads a humans.txt and parses it, logged to redis" do
      REDIS.smembers('hosts_with_humans_txt').must_equal []

      HumansTxt::Downloader.stub(:get, humanstxt) do
        result = subject.download_and_parse('humanstxt.org')

        REDIS.smembers('hosts_with_humans_txt').must_equal ['humanstxt.org']

        result[:team].first[:role].must_equal 'Chef'
      end
    end
  end
end
