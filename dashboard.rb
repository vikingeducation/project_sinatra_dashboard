#!/usr/bin/env ruby

require 'erb'
require 'figaro'
require 'sinatra'
require 'sinatra/reloader'
require_relative './assignment_web_scraper/lib/dice_scraper_controller'

Figaro.application = Figaro::Application.new(
  environment: 'development',
  path: File.expand_path('../config/application.yml', __FILE__)
)
Figaro.load




get '/' do
  erb :index
end

post '/' do

  search_terms = params[:search_terms]
  location     = params[:location]
  erb :search_results, locals: { terms:    search_terms,
                                 location: location }
end
