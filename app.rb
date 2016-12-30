require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/scraper.rb'
require './helpers/geo_ip.rb'
require './helpers/dashboard_helper.rb'
require 'pry-byebug'
require 'mechanize'

helpers DashboardHelper

enable :sessions

ip = development? ? "136.0.16.217" : request.ip

get '/' do
  location = get_location(ip)
  save_sessions(location)
  erb :index
end

post '/results' do
  location = load_sessions
  search = Scraper.new(params[:search], location)
  postings = search.postings
  erb :results, locals: { postings: postings,
                          location: location }
end