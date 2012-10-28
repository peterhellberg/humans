# Handles caching of strings in Redis
#
class RedisCache
  # Get (and set) a string in Redis
  #
  # @param  [String] key Key in Redis
  # @param  [Fixnum] ttl Time to live
  #
  # @return [String]
  #
  def self.get(key, ttl = 60, &blk)
    if REDIS.exists key
      REDIS.get key
    else
      value = yield

      unless value.nil?
        REDIS.setex key, ttl, value
      end

      value
    end
  rescue Redis::CannotConnectError, Errno::ENOENT
    yield
  end

  def self.set(key, value, ttl = 60)
    REDIS.set key, value
  rescue Redis::CannotConnectError, Errno::ENOENT
    # Do nothing
  end
end
