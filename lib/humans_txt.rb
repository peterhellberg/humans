# encoding: utf-8

module HumansTxt
  def self.download_and_parse(host, use_ssl = false)
    Parser.parse Downloader.get(host, use_ssl)
  end
end
