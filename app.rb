#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require_relative 'helpers/scraper.rb'
require_relative 'helpers/locator.rb'
require_relative 'helpers/company_profiler.rb'

enable :sessions

helpers do

  def run_dice_scraper(job_title, location)
    scraper = Scraper::DiceScraper.new(job_title, location, 2015, 06, 15)
    scraper.scrape
  end

  def run_indeed_scraper(job_title, location)
    scraper = Scraper::IndeedScraper.new(job_title, location, 2015, 06, 15)
    scraper.scrape_indeed
  end

  def spoof_ip(ip)
    ip == "127.0.0.1" ? "3.255.255.255" : ip
  end

end


get '/' do

  l = Locator.new(spoof_ip(request.ip))
  location = l.find_location

  session[:visitor_city] = location[0]
  session[:visitor_region] = location[1]
  session[:visitor_zip_code] = location[2]
  session[:visitor_country] = location[3]

  erb :layout, locals: {:results => false}

end

post '/scrape-dice' do

  job_title = params[:job_title]
  if params[:location] != ""
    location = params[:location]
  else
    location = "#{session[:visitor_city]}, #{session[:visitor_region]}"
  end

  array = run_dice_scraper(job_title, location)

  erb :scrapes_table, :locals => { :job_title => job_title, :location => location, :array => array, :results => true}

end

post '/scrape-indeed' do

  job_title = params[:job_title]

  if params[:location] != ""
    location = params[:location]
  else
    location = "#{session[:visitor_city]}, #{session[:visitor_region]}"
  end

  array = run_indeed_scraper(job_title, location)

  erb :scrapes_table, :locals => { :job_title => job_title, :location => location, :array => array, :results => true}

end

# get '/info' do

#   c = CompanyProfiler.new
#   employer = c.extract_info

#   binding.pry

#   erb :layout

# end

