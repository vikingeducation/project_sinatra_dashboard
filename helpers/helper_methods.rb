
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
  employers, @employers_ratings = [], {}
  job_table = SmarterCSV.process("jobs.csv")
  job_table.each do |row|
    employers << row[:company_name]
  end
  employers.uniq!.delete_if {|name| name.is_a?(Integer)}
  employers.each do |co|
    co_rating = @client.company_rating(co)
    sleep rand(0..3)
    @employers_ratings[co] = co_rating
  end
  @employers_ratings
end


def save_employer_ratings(ratings)
  headers = ["Company Name", "Job Title", "Location", "Date Posted", "Job Posting URL", "Overall Rating", "Culture and Values Rating", "Comp. and Bene Rating", "Worklife Balance", "Pros", "Cons"]
  CSV.open("all.csv", "a+", headers: true) do |csv|
    csv << headers if csv.count.eql?(0)
    CSV.foreach('jobs.csv', headers: true) do |row|
      if ratings.has_key?(row["Company Name"])
        combo = row.push(ratings[row["Company Name"]])
      else
        combo = row.push(["NO INFO FOUND"])
      end
      csv << combo
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
