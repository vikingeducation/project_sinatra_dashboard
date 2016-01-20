require 'sinatra'
require 'thin'
require 'erb'
require 'mechanize'
require 'chronic'
require 'byebug'
require 'csv'
require 'sinatra/reloader' if development?
require_relative 'helpers/scraper'


set :servers, ["thin", "puma", "webrick"]


get '/' do
  erb :index
end


post '/' do
  search_term = params[:search]
  job_results = DiceScraper.new.run(search_term)
  erb :dashboard, :locals => { :job_results => job_results}
end