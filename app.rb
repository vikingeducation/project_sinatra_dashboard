require "sinatra"
require "sinatra/reloader" if development?
require "erb"
require "bundler/setup"
require "./dice_scrape/dice_web_scraper.rb"

get '/' do
	scraper = DiceWebScraper.new
	scraper.start_scraping_dice
  	erb :index
end