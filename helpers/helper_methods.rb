# uses web scraper to perform a search based on user search options
def find_jobs(options)
  n = Scraper.new(options[:search_url])
  options.delete(:search_url)
  n.filter_job_listings(options)
end

# determines if search location should be based on ip location or entered city
def determine_search_params(ip_loc)
  location = ip_loc
  options = parameters
  if options[:location] == "ip"
    options[:location] = location
  end
  options
end

# goes through each company returned by webscraper and returns hash containings ratings for each
def find_company_info(ip)
  employers = []
  job_table = SmarterCSV.process("jobs.csv")
  job_table.each do |row|
    employers << row[:company_name]
  end
  employer_ratings(employers, ip)
end

# checks if
def save_employer_ratings(ratings)
  if ratings.nil?
    no_jobs_found
  else
    combine_company_info(ratings)
  end
end


def clear_sessions
  session.clear
end


private


def employer_ratings(employers, ip)
  @client = APIClient.new(WEBSITE, ip, PARAMETERS)
  ratings_hash = {}
  if employers == []
    ratings_hash = nil
  else
    employers.delete_if {|name| name.is_a?(Integer)}.uniq
    employers.each do |co|
      co_rating = @client.company_rating(co)
      sleep rand(0..3)
      ratings_hash[co] = co_rating
    end
  end
  ratings_hash
end


def parameters
  options = { :search_url => params[:url],
              :keywords => params[:search_term],
              :distance => params[:radius],
              :time_type => params[:time_type]
            }
  if params[:search_location] == "ip"
    options[:location] = "ip"
  else
    options[:location] = params[:search_location]
  end
  options
end


def no_jobs_found
  CSV.open('all.csv', 'w+') do |csv|
    csv << ["NO JOBS FOUND"]
  end
end


def combine_company_info(ratings)
  headers = ["Job Title", "Company Name", "Location", "Date Posted", "Job Posting URL", "Overall Rating", "Culture and Values Rating", "Comp. and Bene Rating", "Worklife Balance", "Pros", "Cons"]
  CSV.open("all.csv", "w+", headers: true) do |csv|
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
