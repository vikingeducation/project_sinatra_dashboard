#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'sinatra'
require 'figaro'
require "sinatra/reloader" if development?
require './helpers/scraper_helper.rb'
require './helpers/session_helper.rb'
require './lib/locator.rb'
require './lib/company_profiler.rb'
require 'bootstrap'
require 'httparty'
require 'pry-byebug'

helpers ScraperHelper, SessionHelper
enable :sessions

get '/' do
  set_session

  ua = request.user_agent

  erb :index, locals: {results: nil}
end

post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  zip = session['zip']
  results = scraper_helper(time, search_term, zip)
  set_profiler(results)

  erb :index, locals: {results: results, city: session['city'], region: session['region']}
end
