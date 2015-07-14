require 'sinatra'
require 'csv'
require './scrape.rb'

helpers do
  def load_results
    res = CSV.read("results.csv")
    p res.length
    res
  end
end

get '/index' do
  erb :index, locals: {results: nil}
end

post '/index' do
  search_title = params[:title]
  search_loc = params[:location]
  scraper = DiceScraper.new
  results = scraper.search_jobs(search_title, search_loc)
  erb :index, locals: {results: results}
end

