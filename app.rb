#!/usr/bin/env ruby

require "sinatra"
require "sinatra/reloader" if development?
require_relative './web_scraper'
enable :sessions

def get_zip
  mech = Mechanize.new
  ip = request.ip
  zip = JSON.parse(mech.get("https://www.freegeoip.net/json/173.169.240.17").body)["zip_code"]
end


get "/" do
  session[:zip_code] = get_zip
  erb :index, locals: { data: nil, zip_code: session[:zip_code] }
end


post '/' do

  job_keyword = params[:job]
  job_location = params[:location]
  job_type = params[:type]

  web_scraper = WebScraper.new(job_keyword, job_location, job_type)
  web_scraper.loop_through_job_links
  web_scraper.all_data
  all_data = web_scraper.data

  erb :index, locals: {
    data: all_data, zip_code: session[:zip_code]
  }

end