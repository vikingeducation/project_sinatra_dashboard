require 'rubygems'
require 'httparty'
require 'sinatra'

module IPhelper

  class Ipfinder
    include HTTParty
    attr_accessor :ipjson

    def initialize
      @ipjson = self.class.get("http://www.telize.com/geoip")
    end

  end

end