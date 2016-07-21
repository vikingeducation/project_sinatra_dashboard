require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/job_helpers'
require './helpers/locator_helper'

helpers JobHelpers
helpers Locator

get '/' do
  ip = request.ip
  zip = Locator::Locator.new(request.ip).zip

  erb :index, { locals: { zip: ip } }
end

post '/' do
  erb :search_results, { locals: { q: params[:q], l: params[:l] } }
end
