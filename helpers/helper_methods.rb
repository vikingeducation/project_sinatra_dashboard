require './modules/scraper.rb'

def find_jobs(options)
  n = Scraper.new(options[:search_url])
  options.delete(:search_url)
  n.filter_job_listings(options)
end


def determine_search_params
  location = session[:ip_location]
  options = parameters
  if options[:location].nil?
    options[:location] = location
  end
  options
end


def find_company_info
  @client = APIClient.new(WEBSITE, PARAMETERS)
  @job_table = CSV.open("jobs.csv", :headers => true)
  @job_table.each do |row|
    row.each do |element|
      if element[0] == "Company Name"
        @client.company_rating(element[1])
        sleep rand(0..3)
      end
    end
  end
end


def combine_tables
  @job_table = CSV.open("jobs.csv", :headers => true).read
  @ratings_table = CSV.open("ratings.csv", :headers => true).read
  @combined = @job_table.to_a.each_with_index.map {|row, index| row.to_a.concat(@ratings_table.to_a[index]) }
  CSV.open('all.csv', "a+") do |row|
    @combined.each do |line|
      row << line
    end
  end
end


private


def parameters
  options = { :search_url => params[:url],
              :keywords => params[:search_term],
              :distance => params[:radius],
              :time_type => params[:time_type]
            }
  if params[:search_location] == "ip"
    options[:location] = nil
  else
    options[:location] = params[:search_location]
  end
  options
end
