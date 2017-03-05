require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'pry'
# require 'pry-nav'

# search direct to url page (with parameters)

class JobHunter

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
  end

  def get_me_a_job(title_or_keyword, location)

    @address = "http://www.dice.com/jobs?q=#{title_or_keyword}&l=#{location}"
    @agent.get(@address) do |page|

      # raw job listings
      listings = page.search('div.serp-result-content')
      puts "Found #{listings.length} listings"


      CSV.open('job_hunt_straight_to_results.csv', 'w') do |csv|

        # open a CSV file in append mode
        # CSV will not be created/opened if no listings found
        listings.each do |listing|
          #parse a job listing, shovel it onto the CSV
          parsed = parse_job(listing)
          reviews = employer_reviews(@employer_name, location) 
            # from Glassdoor - see below

          findings = (parsed + reviews).flatten

          csv << findings
          
        end
      end
    end
  end

  private

  # search the div for the elements you want
  # ugly because you have to crawl the page
  # returns array suitable to be appended to CSV
  def parse_job(listing)

    # binding.pry

    title = listing.search('a.dice-btn-link')[0].text
    @employer_name = listing.search('li.employer .dice-btn-link')[0].text
    location = listing.search('li.location').text
    
    job_link = listing.search('a.dice-btn-link')[0].attributes["href"].value.to_s

    relative_date = listing.search('li.posted').text
    date = parse_absolute_date(relative_date)
    
    employer_id = job_link.split('/')[-2]
    job_id = job_link.split('/')[-1]

    [
      date,
      title,
      @employer_name,
      location,
      job_link,
      employer_id,
      job_id
    ].map! { |text| text.gsub(/\s+/, ' ').strip }
  end


  def parse_absolute_date(relative_date)
    case relative_date
    when /([hH]ours?|[mM]inutes?) [aA]go/
      Date.today.strftime('%m/%d/%Y')
    when /\d+.+[Dd]ays? [Aa]go/
      days_ago = relative_date.to_i
      (Date.today - days_ago).strftime('%m/%d/%Y')
    when /\d+.+[Ww]eeks? [Aa]go/
      days_ago = relative_date.to_i * 7
      (Date.today - days_ago).strftime('%m/%d/%Y')
    end
  end 

  def employer_reviews(employer_name, location)
    employer_reviews = CompanyProfiler.new.get_reviews(employer_name, location)
  end



end # class JobHunter


