#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative 'helpers/dice_scraper_helper'
require_relative 'test_results'

helpers DiceScraperHelper

debug = true

get '/' do
  erb :index
end

post '/' do
  if debug
    # Loading and using test_data
    data = TestData.new
    jobs = data.test_data
    p jobs
  else
    terms = params[:terms]
    location = params[:location]
    jobs = search(terms, location)
    jobs = convert_to_hashes(jobs)
  end
  erb :table, :locals => { :jobs => jobs }
end
