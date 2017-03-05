require 'csv'

module StoreResults


  def load_jobs_csv
    jobs = []

      if File.exist?('jobs.csv')

        CSV.foreach('jobs.csv', headers:true) do |row|
          jobs << row
        end

      end

    jobs unless jobs.empty?
  end


  def load_company_profile_csv(company_id)
    if File.exist?('companies.csv')
      profiles = CSV.read('companies.csv', headers:true) 
      profiles.find { |row| row["company_id"] == company_id }
    end
  end


  def existing_csv_job_ids
    jobs = CSV.read('jobs.csv', headers:true) 
    jobs["job_id"]
  end


  def save_jobs_csv(results)

    # Add headings to file, if the file isn't already there
    unless File.exist?('jobs.csv')

      CSV.open('jobs.csv', 'a') do |csv|
        csv << ["title", "job_id", "company", "company_id", "posting_link", 
                "location", "posting_date"]
      end

    end

    CSV.open('jobs.csv', 'a') do |csv|

      results.each do |job|

        row = [job["title"]]
        row << job["job_id"]
        row << job["company"]
        row << job["company_id"]
        row << job["posting_link"]
        row << job["location"] 
        row << job["posting_date"]
        csv << row

      end

    end

  end


  def save_companies_csv(profile)
    
    # Add headings to file, if the file isn't already there
    unless File.exist?('companies.csv')

      CSV.open('companies.csv', 'a') do |csv|
        csv << ["company_name", "company_id", "industry", "website", "number_of_ratings", 
                "overall_rating", "culture_rating", "compensation_rating", "review_date",
                "reviewer_job_title", "review_pros", "review_cons"]
      end

    end

    CSV.open('companies.csv', 'a') do |csv|

      row = [profile["company_name"]]
      row << profile["company_id"]
      row << profile["industry"]
      row << profile["website"]
      row << profile["number_of_ratings"]
      row << profile["overall_rating"] 
      row << profile["culture_rating"]
      row << profile["compensation_rating"]

      if profile["review?"]
        row << profile["review_date"]
        row << profile["reviewer_job_title"]
        row << profile["review_pros"]
        row << profile["review_cons"]
      end

      csv << row

    end

  end

end