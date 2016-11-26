require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'mechanize'
require 'csv'
require 'httparty'
require_relative 'scraper'
require_relative 'helper'
enable :session
helpers Locator

get '/' do
  # run scraper if search
  unless session["default_location"]
    session["default_location"] = get_ip_location
  end
  
  query = params[:query]
  location = params[:location]

  array_mine =[[]]

  if query || location
    query = " " if query.nil?
    array_mine = Dice.new.run(query, location)
  else
  end

  erb :index, locals: {input: array_mine, default_location: session["default_location"]}
end
