# encoding: utf-8

require "net/http"
require "net/https"

require 'open-uri'

module HumansTxt
  class Downloader
    attr_reader :host, :use_ssl

    def initialize(host, use_ssl = false)
      @host     = host
      @use_ssl  = use_ssl
    end

    def self.get(host, use_ssl = false)
      new(host, use_ssl).get
    end

    def get
      available?? get_humans_txt : ''
    end

    def available?
      head_humans_txt.code == '200'
    rescue SocketError
      false
    end

    private

    def head_humans_txt
      if use_ssl
        http = Net::HTTP.new(host, 443)
        http.use_ssl      = true
        http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
        http.request_head('/humans.txt')
      else
        http = Net::HTTP.new(host, 80)
        http.request_head('/humans.txt')
      end
    end

    def get_humans_txt
      scheme = use_ssl ? 'https' : 'http'
      url = "#{scheme}://#{host}/humans.txt"

      puts url

      res = open(url, "r:utf-8")
      res.status[0] == '200' ? res.read : ''
    end
  end
end
