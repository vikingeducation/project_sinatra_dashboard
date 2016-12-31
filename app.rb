require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'mechanize'
require './helpers/dashboard_helper.rb'

helpers DashboardHelper

enable :sessions

ip = development? ? "136.0.16.217" : request.ip

get '/' do
  location = get_location(ip)
  save_sessions(location)
  erb :index
end

post '/results' do
  user_agent = env["HTTP_USER_AGENT"]
  location = load_location

  postings = conduct_search(params[:search], location)
  profiles = company_profiles(postings, ip, user_agent)

  erb :results, locals: { postings: postings,
                          profiles: profiles,
                          location: location }
end