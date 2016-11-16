require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'mechanize'
require 'csv'
require_relative 'scraper'

get '/' do
  # run scraper if search
  query = params[:query]
  location = params[:location]
  array_mine =[[]]
  if query || location
    query = " " if query.nil?
    array_mine = Dice.new.run(query, location)
  else
  end
  erb :index, locals: {input: array_mine}
end
