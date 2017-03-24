require "sinatra"
require "sinatra/reloader" if development?
require "erb"
require_relative "scraper"

enable :session

get "/" do
  erb :index
end

post "/" do
  scraper = Scraper.new
  option = params[:scrape].to_i
  result = scraper.scrape_first_page if option == 1
  result = scraper.scrape_since(Time.now) if option == 2
  locals = {locals: {result: result}}
  erb :result, locals
end
