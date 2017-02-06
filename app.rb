require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'json'
require 'thin'
require 'httparty'
require 'envyable'
require_relative 'helpers/dashboard_helper'
require_relative 'models/dice_searcher'
require_relative 'models/saver'
require_relative 'models/locator'
require_relative 'models/company_profiler'
require_relative 'models/result'
Envyable.load('config/env.yml')

helpers DashboardHelper

set :server, %w[thin]

enable :sessions

ip = settings.development? ? '119.81.124.82' : request.ip

get '/' do
  set_session(ip)
  erb :index, :locals => { 'location' => session['location'], 'advanced_form' => session['advanced_form'], 'searched' => session['search_loc'] }
end

post '/search' do
  opts = params_to_opts(params)
  dice = DiceSearcher.new(opts)
  ratings = CompanyProfiler.new(dice.results, ip)
  ratings.get_company_ratings
  compiled = merge_data(dice.results, ratings.ratings)
  save = Saver.new(compiled)
  session['search_loc'] = params['for_loc']
  session.delete(:advanced_form)
  redirect '/'
end

get '/advanced_search' do
  session['advanced_form'] = 1
  redirect '/'
end

get '/simple_search' do
  session.delete(:advanced_form)
  redirect '/'
end

get '/results' do
  erb :results, :locals => { 'searched' => session['search_loc']}
end
