# encoding: utf-8

module HumansTxt
  def self.download_and_parse(host, use_ssl = false)
    data = Downloader.get(host, use_ssl)

    REDIS.sadd 'hosts_with_humans_txt', host unless data.empty?

    Parser.parse(data)
  end
end
