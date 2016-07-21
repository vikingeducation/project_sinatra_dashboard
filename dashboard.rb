#!/usr/bin/env ruby

require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "thin"
require "mechanize"
require_relative 'dice_scraper'
require "httparty"

helpers do

  def read_file
    File.readlines("csv_file.csv")
  end

  def my_response
    return HTTParty.get("http://freegeoip.net/json/99.3.66.230")["zip_code"] if Sinatra::Base.development?
    HTTParty.get("http://freegeoip.net/json/#{request.ip}")["zip_code"]
  end

end

get "/" do
  zip_code = my_response unless my_response.nil?
  erb :index, :locals => { zip_code: zip_code }
end

get "/jobs_list" do

  unless Pathname.new("csv_file.csv").exist?
    searcher = Scraper.new(params[:q], params[:l])
    searcher.write_to_csv(searcher.build_job_hash)
  end

  jobs = read_file

  erb :jobs_list, :locals => { :jobs => jobs }
end
