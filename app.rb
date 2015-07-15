#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require_relative 'helpers/scraper.rb'

helpers Scraper do

  def run_scraper(job_title, location)
    scraper = Scraper::DiceScraper.new(job_title, location, 2015, 06, 15)
    scraper.scrape
  end

end


get '/' do

  erb :index
end

post '/scrape' do

  job_title, location = params[:job_title], params[:location]

  array = run_scraper(job_title, location)

  erb :scrapes_table, :locals => { :job_title => job_title, :location => location, :array => array}

end

