require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'pry'


class JobHunter

  def initialize(job_title="rails", location="San Jose")
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @address = 'http://www.dice.com'
    @job_title = job_title
    @location = location
  end

  def get_me_a_job
    results = []
    puts
  

    @agent.get(@address) do |page|

      # Note that we could skip actually submitting the form by just
      # going straight to the results page and manually populating
      # the GET params in the URL... but we didn't so you can see the
      # form submission.
      puts 'Searching...'
      search_result = page.form_with(:action => '/jobs') do |search|
        
        # Set the GET params for this search (e.g. `q` and `l`)
        search.q = @job_title #params[:job]
        search.l = @location #params[:location]
      end.submit

      #raw job listings
      listings = search_result.search('div.serp-result-content')
      puts "Found #{listings.length} listings"

      listings.each do |listing|

        #open a CSV file in append mode
        CSV.open('job_hunt.csv', 'a+') do |csv|
          #parse a job listing, shovel it onto the CSV
          parsed = parse_job(listing)
          puts "#{parsed[0..2]}"
          csv << parsed
          results << parsed
        end

      end

    end


    puts 'Done'
    puts
    #binding.pry
    return results
    
    
  end


  private

  # search the div for the elements you want
  # ugly because you have to crawl the page
  # returns array suitable to be appended to CSV
  def parse_job(listing)
    title = listing.search('a.dice-btn-link')[0].text.split
    employer_name = listing.search('li.employer').text.split
    location = listing.search('li.location').text
    
    job_link = listing.search('a.dice-btn-link')[0].attributes["href"].value

    relative_date = listing.search('li.posted').text
    date = parse_absolute_date(relative_date)
    
    employer_id = job_link.split('/')[-2]
    job_id = job_link.split('/')[-1]

    [
      date,
      title,
      employer_name,
      location,
      job_link,
      employer_id,
      job_id
    ]
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
end
job = JobHunter.new

#job.get_me_a_job



