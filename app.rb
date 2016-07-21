require 'sinatra'
require 'erb'
require './helpers/script.rb'
require './helpers/view_helpers.rb'

helpers ScraperHelper
helpers ViewHelpers

get '/' do
  erb :index, locals: { jobs: nil }
end

post '/scraper' do
  query = params[:keyword]
  location = params[:location]
  scraper = DiceScraper.new(query, location)
  jobs = scraper.run

  erb :index, locals: { jobs: jobs }
end