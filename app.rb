#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require_relative 'helpers/scraper.rb'

helpers Scraper do

  def run_dice_scraper(job_title, location)
    scraper = Scraper::DiceScraper.new(job_title, location, 2015, 06, 15)
    scraper.scrape
  end

  def run_indeed_scraper(job_title, location)
    scraper = Scraper::IndeedScraper.new(job_title, location, 2015, 06, 15)
    scraper.scrape_indeed
  end

end


get '/' do

  erb :index
end

post '/scrape-dice' do

  job_title, location = params[:job_title], params[:location]

  array = run_dice_scraper(job_title, location)

  erb :scrapes_table, :locals => { :job_title => job_title, :location => location, :array => array}

end

post '/scrape-indeed' do

  job_title, location = params[:job_title], params[:location]

  array = run_indeed_scraper(job_title, location)

  erb :scrapes_table, :locals => { :job_title => job_title, :location => location, :array => array}

end

