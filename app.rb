require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'mechanize'
require 'csv'
require_relative 'scraper'

get '/' do
  erb :index
  # run scraper if search
  query = params[:query]
  location = params[:location]
  if query || location
    query = " " if query.nil?
    Dice.new(query, location).run
  else
    CSV.open('jobs.csv', 'w') do |csv|
      csv << []
    end
  end
end





# Refreshing the page should kick off scraping operations.


# Load Bootstrap into your Sinatra app and use it to put some bare-bones styling around the job hunt widget you built. Look into Bootstrap's table styling classes -- they are very easy to use.