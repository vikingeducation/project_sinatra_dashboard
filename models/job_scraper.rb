require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv' 
require_relative 'csv_writer'

Job = Struct.new(:title, :company, :location, :link, :post_date, :job_id )

class JobScraper

  attr_accessor :results, :scraper, :page, :csv_file

  def initialize
    # Instantiate a new Mechanize
    @scraper = Mechanize.new

    # Grab and parse our page in one step
    @page = @scraper.get('http://uk.dice.com/')
    @results = []

    # this gives your Mechanize object
    # an 0.5 second wait time after every HTML request
    @scraper.history_added = Proc.new { sleep 0.5 }
    @csv_file = CsvWriter.new
  end

  def create_search(search_term, location, radius)
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
