require 'sinatra'
require 'sinatra/reloader' if development?
require 'thin'
require 'mechanize'
require 'byebug'
require 'chronic'
require 'csv'
require_relative 'lib/scraper'
require_relative 'lib/location'

helpers do
  def user_location
    if Sinatra::Base.development?
      session[:location] = Location.location_for('69.116.162.235')
    else
      session[:location] ||= Location.location_for(request.ip)
    end
  end
end

get '/' do
  puts user_location
  job_results = []
  if query = params[:job_query]
    job_results = DiceScraper.new(user_location).scrape_jobs(query)
    # byebug
  end
  erb :job_search, locals: {job_results: job_results}
end

