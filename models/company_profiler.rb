# ./models/company_profiler.rb
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'httparty'

# Job = Struct.new(:title, :company, :location, :link, :post_date, :job_id )

class CompanyProfiler

  include HTTParty

  base_uri 'api.glassdoor.com/api/api.htm'
  PARTNER_ID = ENV["PARTNER_ID"]
  API_KEY = ENV["API_KEY"]
  params = {v: "1",
    format: "json",
    "t.p": PARTNER_ID,
    "t.k": API_KEY,
    userip: "127.0.0.1",
    useragent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
  }


  # http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0

  def initialize
    @response = self.class.get(params)
    # self.class.default_params
  end

  def create_search(search_term=Ruby, location=London, radius=10)
    dice_form = @page.form
    # Enter the search terms and submit the form
    dice_form.SearchTerms = search_term
    dice_form.LocationSearchTerms = location
    dice_form.Radius = radius.to_i

    dice_form.checkbox_with(:name => 'JobTypeFilter_2').check
    button = dice_form.button_with(:value => "Search")
    # Actually submit the form
    @page = @scraper.submit(dice_form, button)
  end
    

  def extract_job_details
    links = @page.parser.css("h2.standardLink").children

    @page = @page.parser.css("div#SearchResults").text.strip
    # remove from the beginning of the page
    @page = @page.split("\"MESSAGE.ADVERT_SHORTLIST_COUNT_ALERT\" NOT FOUND\n\n\n\n\n\n\n\n\n\n\n")

    i = 0
    @page.each do |job|
      listing = Job.new
      listing.title = job.scan(/\A(.*)\n\nSalary/).join.strip
      listing.company = job.scan(/Advertiser\n\n(.*)/).join.strip
      listing.location = job.scan(/Location:\n(.*)/).join.strip
      listing.link = links[i].attributes['href'].value
      listing.post_date = job.scan(/Last Updated Date\n\n(.*)/).join.strip
      job_link = links[i].attributes['id'].value
      listing.job_id = job_link.scan(/TITLE\[([0-9]+)\]/).join.strip
      @results << listing
      i += 1
    end
  end
end
