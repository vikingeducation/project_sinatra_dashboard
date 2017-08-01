require './modules/scraper.rb'

def find_jobs(options)
  n = Scraper.new(options[:search_url])
  options.delete(:search_url)
  n.filter_job_listings(options)
end


def search_params
  options = { :search_url => params[:url],
              :keywords => params[:search_term],
              :location => params[:search_location],
              :distance => params[:radius],
              :time_type => params[:time_type] }
end
