
require 'sinatra'
require 'sinatra/reloader' if development?
require './scraper.rb'


get '/' do
  scraper = DiceScraper.new
  scraper.scrape

  job_lines = File.open("dice_job.csv").readlines

  job_table = []
  job_lines.each do |job_line|
    job_line_array = job_line.split(",")
    job_table <<  job_line_array
    # job_table.each do |row|
    # end
  end
  erb :index, locals: { job_table: job_table}
end


post '/' do
 
end
