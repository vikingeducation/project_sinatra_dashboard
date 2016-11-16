#!/usr/bin/env ruby

require 'erb'
require 'figaro'
require 'sinatra'
require 'sinatra/reloader'
require_relative './assignment_web_scraper/lib/scraper'
require_relative './assignment_web_scraper/lib/dice_jobs_page_parser'
require_relative './assignment_web_scraper/lib/dice_scraper_controller'

Figaro.application = Figaro::Application.new(
  environment: 'development',
  path: File.expand_path('../config/application.yml', __FILE__)
)
Figaro.load




get '/' do
  erb :index
end

get '/search_results' do

  search_terms = params[:search_terms]
  location     = params[:location]
  jobs = DiceScraperController.new.search(search_terms, location)
  erb :search_results, locals: { terms:    search_terms,
                                 location: location,
                                  jobs: jobs }
end
