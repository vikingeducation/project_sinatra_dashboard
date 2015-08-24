require 'sinatra'
require './helpers/dice.rb'
require './helpers/gdhelper.rb'

helpers Dice_scraper
helpers Glassdoorhelper


get '/' do
    erb :welcome
end

get '/search' do
   job = params[:job]
   location = params[:place]
   dice_job = Dice_scraper::Dice_tool.new(job,location)
   #job_list = dice_job.jobdb
   erb :job_screen, :locals => {:job_list => dice_job.jobdb}
   #erb :test, :locals => {:job => job, :location => location}
end
