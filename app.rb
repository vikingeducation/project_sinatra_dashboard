require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/job_helpers'
require './helpers/locator_helper'
require './helpers/company_profiler_helper'

helpers JobHelpers
helpers Locator

get '/' do
  ip = request.ip
  ip = '75.37.48.0'
  @client = Locator::Locator.new(ip)
  erb :index, { locals: { zip: @client.zip } }
end

post '/' do
  ip = '75.37.48.0'
  @client = Locator::Locator.new(ip)
  profiler = CompanyProfiler::CompanyProfiler.new

  erb :search_results, { locals: { q: params[:q], l: params[:l], city: @client.city, region: @client.region } }
end
