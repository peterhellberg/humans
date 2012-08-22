# encoding: utf-8

require_relative "spec_helper"

describe HumansTxt do
  subject { HumansTxt }

  let(:humanstxt) { IO.read('spec/fixtures/humanstxt.org') }

  before do
    REDIS.flushdb
  end

  def logged_hosts
    REDIS.smembers('hosts_with_humans_txt')
  end

  describe "download_and_parse" do
    it "downloads a humans.txt and parses it, logged to redis" do
      REDIS.smembers('hosts_with_humans_txt').must_equal []

      HumansTxt::Downloader.stub(:get, humanstxt) do
        result = subject.download_and_parse('humanstxt.org')
        result[:team].first[:role].must_equal 'Chef'
      end

      logged_hosts.must_equal ['humanstxt.org']
    end

    it "doesn’t log empty responses" do
      HumansTxt::Downloader.stub(:get, '') do
        subject.download_and_parse('foo').must_equal({})
      end

      HumansTxt::Downloader.stub(:get, '{}') do
        subject.download_and_parse('foo').must_equal({})
      end

      logged_hosts.must_equal []
    end
  end
end
