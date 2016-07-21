require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/job_helpers'

helpers JobHelpers

get '/' do
  erb :index
end

post '/' do
  erb :search_results, { locals: { q: params[:q], l: params[:l] } }
end
