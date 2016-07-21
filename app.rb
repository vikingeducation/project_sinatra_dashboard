require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/job_helpers'

helpers JobHelpers

get '/' do
  @ip = request.ip
  erb :index
end

post '/' do
  erb :search_results, { locals: { q: params[:q], l: params[:l] } }
end
