#!/usr/bin/env ruby

require "bundler/setup"
require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "thin"
require "mechanize"
require_relative 'dice_scraper'
require_relative 'company_info'
require "httparty"

helpers do

  def read_file
    File.readlines("csv_file.csv")
  end

  def my_response
    return HTTParty.get("http://freegeoip.net/json/99.3.66.230") if Sinatra::Base.development?
    HTTParty.get("http://freegeoip.net/json/#{request.ip}")
  end

end

get "/" do
  response_object = my_response unless my_response.nil?
  zip_code = response_object["zip_code"]
  erb :index, :locals => { zip_code: zip_code }
end

get "/jobs_list" do
  response_object = my_response unless my_response.nil?
  city = response_object["city"]

  unless Pathname.new("csv_file.csv").exist?
    searcher = Scraper.new(params[:q], params[:l])
    searcher.write_to_csv(searcher.build_job_hash)
  end

  jobs = read_file

  erb :jobs_list, :locals => { jobs: jobs, city: city }
end
