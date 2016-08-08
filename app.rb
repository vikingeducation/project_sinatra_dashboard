require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/jobs_helper.rb'
helpers JobHelper
enable :sessions

get '/' do
  erb :index
end

post '/search' do
  search_text = params[:search_text]
  @jobs = get_jobs(search_text)
  erb :index
end