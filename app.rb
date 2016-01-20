require 'sinatra'
require 'thin'
require 'erb'
require 'mechanize'
require 'chronic'
require 'byebug'
require 'csv'
# require 'sinatra/reloader' if development?
require_relative 'helpers/scraper'
require_relative 'helpers/locator'

enable :sessions
set :servers, ["thin", "puma", "webrick"]


get '/' do
  locator = Locator.new #(request.ip)
  location = locator.readable_location
  session['location'] = location
  erb :index, :locals => { :location => location }
end


post '/' do
  search_term = params[:search]
  job_results = DiceScraper.new(session['location']).run(search_term)
  erb :dashboard, :locals => { :job_results => job_results, :location => session['location'] }
end

