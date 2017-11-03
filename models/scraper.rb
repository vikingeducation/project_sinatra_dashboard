require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'json'
require 'yaml'
require 'pry'

require_relative 'job'

class Scraper
  attr_reader :agent
  attr_accessor :csv_filename

  YAML_DATA_FILE = "data/temp.yaml"
  BASE_URL = "https://www.dice.com"
  SEARCH_URI = "jobs/advancedResult.html"

  def initialize
    @agent = Mechanize.new
    @matches = []
    @csv_filename = ''
  end

  def scrape(keywords:, location:, distance:, remote:)
    set_up_agent
    retrieve_job_results_via_query_url(keywords, location, distance, remote)
    save_matches_to_yaml
    export_matches
  end

  def retrieve_matches_from_yaml
    records = YAML.load(File.read(YAML_DATA_FILE))

    records.each do |record|
      @matches << YAML.load(record)
    end
    @matches
  end

  private

  def set_up_agent
    agent.history_added = Proc.new { sleep 0.5 }
    agent.user_agent_alias = 'Mac Safari'
  end

  def retrieve_job_results_via_query_url(keywords, location, distance, remote)
    puts "Finding results..."

    url = "#{BASE_URL}/#{SEARCH_URI}?for_one=&for_all=#{keywords}&for_exact=&for_none=&for_jt=&for_com=&for_loc=#{location}&sort=relevance&telecommute=#{remote}&radius=#{distance}"

    results_page = agent.get(url)
    go_to_job_page(results_page)
  end

  # This method is no longer being used, but I'm keeping this as
  # an example of how to fill out a form and submit it
  def retrieve_job_results_via_form(keywords, location)
    agent.get(BASE_URL) do |page|
      result = page.form_with(:id => 'search-form') do |form|
        job_title = form.field_with(:id => 'search-field-keyword')
        job_title.value = keywords

        job_location = form.field_with(:id => 'search-field-location')
        job_location = location
      end.submit

      go_to_job_page(result)
    end
  end

  def go_to_job_page(results_page)
    puts "Scraping each job page..."
    results_page.links_with(:href => /jobs\/detail/).each do |link|
      job = Job.new
      job.description_url = "#{BASE_URL}#{link.href}"
      job_page = link.click
      build_job(job_page, job)
    end
  end

  def build_job(job_page, job)
    job.title = job_page.root.css('h1.jobTitle').text.strip
    puts "Building job #{job.title}..."

    job.job_id = get_company_info(job_page, 'Position Id :')
    job.company = job_page.root.css('li.employer a span').text.strip
    job.company_id = get_company_info(job_page, 'Dice Id :')
    job.description = job_page.root.css('#jobdescSec[itemprop="description"]').text.strip
    job.location = job_page.root.css('li.location span').text.strip
    job.date_posted = job_page.root.at("meta[@itemprop='datePosted']")[:content].gsub(/T(.*)/,'')
    job.salary = job_page.root.css('.iconsiblings span.mL20[itemprop="baseSalary"]').text.strip
    job.skills = job_page.root.css('.iconsiblings[itemprop="skills"]').text.strip
    job.remote = job_page.root.css('.iconsiblings span.mL20').text.strip

    add_job_to_matches(job)
  end

  def get_company_info(page, field_name)
    page.root.css('.company-header-info > .row > .col-md-12').each do |row|
      @data = row.text.strip if row.text.include?(field_name)
    end
    @data = @data.gsub(/#{field_name}/,'').strip
  end

  def add_job_to_matches(job)
    @matches << job
  end

  def save_matches_to_yaml
    puts "Caching matches for results page..."

    converted_matches = @matches.map(&:to_yaml)

    File.open(YAML_DATA_FILE,"w") do |f|
      f.write(converted_matches)
    end
  end

  def export_matches
    puts "Exporting matches to CSV..."
    @csv_filename = "exports/jobs-#{Time.now}.csv"
    CSV.open(@csv_filename, 'a') do |csv|
      csv << [ "title",
              "job_id",
              "description_url",
              "company",
              "company_id",
              "location",
              "description",
              "date_posted",
              "salary",
              "skills",
              "remote" ]
      @matches.each do |job|
        csv << [ job.title,
                job.job_id,
                job.description_url,
                job.company,
                job.company_id,
                job.location,
                job.description,
                job.date_posted,
                job.salary,
                job.skills,
                job.remote ]
      end #matches
    end #CSV
  end

end #scraper
