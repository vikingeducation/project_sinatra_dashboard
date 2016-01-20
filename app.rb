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
  get_api_location if session['zip'].nil?
  erb :index, locals: {results: nil}
end

post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  results = scraper_helper(time, search_term, session['zip'])

  erb :index, locals: {results: results, city: session['city'], region: session['region']}
end

def get_api_location
  response = HTTParty.get("https://freegeoip.net/json/108.185.219.255")
  session['city'] = "#{response['city']}"
  session['region'] = "#{response['region_code']}"
  session['zip'] = "#{response['zip_code']}"
end

# country_code region_code city
