require 'sinatra'
require 'json'

require './public/assets/diceapi.rb'
require './helpers/dashboard_helper.rb'

helpers DashboardHelper

enable :sessions

get '/' do
  load_query

  erb :"index.html"
end

post '/dashboard' do
  @form_input = params
  @job_query = DiceApi.new(@form_input[:job],@form_input[:state])

  save_query(@job_query.find_jobs)
  #erb :"index.html"
  #redirect '/index.html'
  redirect '/'
end