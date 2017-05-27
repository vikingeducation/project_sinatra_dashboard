require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_site_scraper'

get '/' do
  erb :index
end
