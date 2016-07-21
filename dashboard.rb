#!/usr/bin/env ruby

require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "thin"
require "mechanize"
require_relative 'dice_scraper'

helpers do

  def read_file
    File.readlines("csv_file.csv")
  end

end

get "/" do
  erb :index
end

get "/jobs_list" do

  unless Pathname.new("csv_file.csv").exist?
    searcher = Scraper.new(params[:q], params[:l])
    searcher.write_to_csv(searcher.build_job_hash)
  end

  jobs = read_file

  erb :jobs_list, :locals => { :jobs => jobs }
end
