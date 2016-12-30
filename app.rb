require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/scraper.rb'
require 'pry-byebug'
require 'mechanize'

enable :sessions

get '/' do
  erb :index
end

post '/results' do
  search = Scraper.new(params[:search], params[:zip])
  postings = search.postings
  erb :results, locals: { postings: postings }
end