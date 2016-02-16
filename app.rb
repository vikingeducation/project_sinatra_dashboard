=begin
  Displaying Your Scrape

  To start, display the data you scraped from your original Mechanize scraper from the scraping assignment by pulling that code in from your previous repo and getting it working in a new Sinatra App.

  1. Set up a basic Sinatra app with a Gemfile. (DONE)

  2. Build the core view layout (DONE)
  and the index.erb template (the home page) which will display the information you want. (DONE)

  3. Refreshing the page should kick off scraping operations.

  4. There should be a form for your search query, which tells the scraper what to search for.

  5. Display your job hunt data in a table on the page.

  6. Load Bootstrap into your Sinatra app and use it to put some bare-bones styling around the job hunt widget you built. Look into Bootstrap's table styling classes -- they are very easy to use.
=end

# 3. Refreshing the page should kick off scraping operations.
# IT works but because the scraping takes so long, the page doesn't load, do you need to have the erb on the bottom?

require 'rubygems'
require 'bundler/setup'
require './assignment_web_scraper/lib/dice_scraper'
Bundler.require(:default)

get '/index' do
  erb :index, locals: {searched: false}
end

post '/index' do
  results = DiceScraper.new('ruby junior').get_results_array
  erb :index, locals: {searched: true, results: results}
end
