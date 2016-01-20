require 'sinatra'
require 'thin'
require 'erb'
require 'mechanize'
require 'chronic'
require 'byebug'
require 'csv'
require 'sinatra/reloader' if development?
require './helpers/scraper.rb'


set :servers, ["thin", "puma", "webrick"]




# class MyApp < Sinatra::Base

#   helpers DiceScraper

#   get '/' do
#     erb :index
#   end
# end

# MyApp.run!

# helpers DiceScraper


get '/' do
  erb :index
end


post '/' do
  search_term = params[:search]
  job_results = run(search_term)
  erb :dashboard, :locals => { :job_results => job_results}
end