require_relative "spec_helper"

describe RedisCache do
  subject { RedisCache }

  before do
    REDIS.flushdb
  end

  describe "get" do
    it "returns a string stored in Redis" do
      REDIS.set 'foo', 'bar'
      subject.get('foo') { 'abc' }.must_equal 'bar'
    end

    it "returns a string based on the block" do
      subject.get('foo') { 'abc' }.must_equal 'abc'
      REDIS.get('foo').must_equal 'abc'
    end

    it "should set a default ttl of 60s for the key stored in Redis" do
      subject.get('bar') { '123' }
      REDIS.ttl('bar').must_equal 60
    end

    it "returns a string based on the block even if Redis is not running" do
      REDIS.stub(:exists, ->(key){ raise Redis::CannotConnectError }) do
        subject.get('bar') { '123' }.must_equal '123'
      end

      REDIS.stub(:exists, ->(key){ raise Errno::ENOENT }) do
        subject.get('foo') { '456' }.must_equal '456'
      end
    end
  end
end
