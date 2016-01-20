
require 'sinatra'
require 'sinatra/reloader' if development?
require './scraper.rb'


get '/' do
  scraper = DiceScraper.new
  scraper.scrape
  job_array = CSV.read("dice_job.csv")
  erb :index, locals: { job_table: job_array}
end

post '/' do

end
