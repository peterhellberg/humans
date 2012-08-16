# encoding: utf-8

require_relative "../spec_helper"

describe "Downloader" do
  subject { HumansTxt::Downloader }

  let(:d) { s('example') }

  describe "initialize" do
    it "sets the host attribute" do
      d.host.must_equal 'example'
    end
  end

  describe "get" do
    it "returns the humans.txt as a string" do
      d.stub(:available?, true) do
        d.stub(:get_humans_txt, 'bar') do
          d.get.must_equal 'bar'
        end
      end
    end

    it "returns an empty string if not available" do
      d.stub(:available?, false) do
        d.get.must_equal ''
      end
    end
  end

  describe "available?" do
    it "returns false on socket error" do
      d.stub(:head_humans_txt, -> { raise SocketError }) do
        d.available?.must_equal false
      end
    end

    it "returns true if the status is 200" do
      d.stub(:head_humans_txt, OpenStruct.new(code: '200')) do
        d.available?.must_equal true
      end
    end

    it "returns false if the status isn’t 200" do
      status_404 = OpenStruct.new(code: '404')
      status_503 = OpenStruct.new(code: '503')

      d.stub(:head_humans_txt, status_404) { d.available?.must_equal false }
      d.stub(:head_humans_txt, status_503) { d.available?.must_equal false }
    end
  end
end
