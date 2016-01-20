#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'sinatra'
require "sinatra/reloader" if development?
require './helpers/scraper_helper.rb'
require 'bootstrap'
require 'httparty'
require 'pry-byebug'

helpers ScraperHelper
enable :sessions

get '/' do
  get_api_location
  erb :index, locals: {results: nil}
end


post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  results = scraper_helper(time, search_term)

  erb :index, locals: {results: results}
end

def get_api_location
  response = HTTParty.get("https://freegeoip.net/json/174.60.246.251")
end

# country_code region_code city