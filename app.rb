#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'sinatra'
require 'figaro'
require "sinatra/reloader" if development?
require './helpers/scraper_helper.rb'
require './lib/locator.rb'
require './lib/company_profiler.rb'
require 'bootstrap'
require 'httparty'
require 'pry-byebug'

helpers ScraperHelper
enable :sessions

get '/' do
  if session['zip'].nil?
    locator = Locator.new
    locator.get_api_location
    session['city'] = locator.city
    session['region'] = locator.region
    session['zip'] = locator.zip
  end

  ua = request.user_agent

  erb :index, locals: {results: nil}
end

post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  results = scraper_helper(time, search_term, session['zip'])
  erb :index, locals: {results: results, city: session['city'], region: session['region']}
end

# country_code region_code city
