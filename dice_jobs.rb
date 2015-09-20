require_relative 'mechanize_agent'
require 'chronic'

class DiceJobs

  def initialize
    @agent = SlowMech.new
  end


  def search(keywords, locations, old_job_ids = [])
    @old_job_ids = old_job_ids
    links = get_links(keywords, locations)
    get_details(links)
  end


  private


  def get_links(keywords, locations)
    links = []

    locations.each do |location|
      puts "Getting results for location: #{location}...\n"

      # Dice search results page for first 100 results, 40 mile radius of ZIP
      search_url = "https://www.dice.com/jobs/q-" +
                   "#{keywords.join("+")}-l-#{location}" + 
                   "-radius-40-startPage-1-limit-100-jobs.html"
      page = get_search_page(search_url) 

      unless page.nil?

        page.links_with(:href => /jobs\/detail/).each do |mechlink|
          link = mechlink.uri.to_s
          # Dice appends search query to posting link, remove this
          link.slice!(/&q(.*)/)
          # links appear twice on page, so check for duplicates
          # also handles duplicates from overlaping locations
          links << link unless links.include?(link)
        end

      end

    end

    links
  end


  def get_search_page(url)
    begin
      @agent.get(url)
    rescue => error
      puts "Error getting search page: #{error}"
    end
  end


  def get_details(job_links)
    results = []

    job_links.each do |url|
      puts "Working on post URL ending ... #{url[33..-1]}\n"
      
      job_page = get_job_page(url)

      # job_page will be nil if there were any errors
      unless job_page.nil?
        job = {}
        job["title"] = job_page.search("h1.jobTitle").text
        job["company"] = job_page.link_with(:href => /company/).text
        job["posting_link"] = url
        job["location"] = job_page.search("li.location").text

        # Need to trim up some text from Job and Company IDs
        raw_job_id = job_page.search('div.company-header-info').search('div:contains("Position Id")')[-1].text
        job["job_id"] = trim_job_id(raw_job_id)

        raw_company_id = job_page.search('div.company-header-info').search('div:contains("Dice Id")')[-1].text
        job["company_id"] = trim_company_id(raw_company_id)

        # Turn Dice posting dates like "2 weeks ago" into real dates
        posting_date = job_page.search("li.posted").text
        job["posting_date"] = get_real_date(posting_date)

        unless @old_job_ids.include?(job["job_id"])
          results << job
        end
      end

    end

    results
  end


  def get_job_page(url)
    begin
      @agent.get(url)
    rescue => error
      puts "Error getting job page: #{error}"
    end
  end


  def trim_job_id(raw_job_id)
    raw_job_id.slice!("Position Id : ")
    raw_job_id
  end


  def trim_company_id(raw_company_id)
    raw_company_id.slice!("Dice Id : ")
    raw_company_id
  end


  def get_real_date(posting_date)
    if posting_date == "Posted Moments Ago"
      Time.now.strftime("%F")
    else
      begin
        posting_date.slice!("Posted ")
        Chronic.parse(posting_date).strftime("%F")
      rescue
        return "Unknown"
      end
    end
  end
  
end