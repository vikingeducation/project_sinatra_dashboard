#!/usr/bin/env ruby

require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "thin"
require "mechanize"
require_relative 'dice_scraper'


get "/" do
  
  unless Pathname.new("csv_file.csv").exists?
    searcher = Scraper.new("developer", "raleigh, nc")
    searcher.submit_form
    searcher.write_to_csv(searcher.build_job_hash)
  end

  erb :index
end
