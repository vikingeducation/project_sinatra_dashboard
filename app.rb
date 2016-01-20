require 'sinatra'
require 'sinatra/reloader' if development?
require 'thin'
require 'mechanize'
require 'byebug'
require 'chronic'
require 'csv'
require_relative 'lib/scraper'

get '/' do
  job_results = []
  if query = params[:job_query]
    job_results = DiceScraper.new.scrape_jobs(query)
    # byebug
  end
  erb :job_search, locals: {job_results: job_results}
end

