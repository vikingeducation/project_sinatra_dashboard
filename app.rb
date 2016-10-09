require 'sinatra'
require 'json'
require 'pry-byebug'

# the core view layout shows the job listings in a table  (index.erb)
# refreshing page starts job search
# form for search query
	# location ( city, state )
	# job
# job data to be displayed on table in page
# use bootstrap

get '/' do

	erb :layout

end