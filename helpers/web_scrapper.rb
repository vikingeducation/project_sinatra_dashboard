
require 'rubygems'
require 'mechanize'
require './helpers/company_profiler.rb'
require 'pry'

module JobScrapper

class WebScrapper

  def initialize
    @job_posts = []
  end

  def parse_all_job_adverts(city, keyword, company, date, ip)
    date == "" ? date = ((Time.now - 100*24*60*60).strftime "%Y-%m-%d") : date
    # number_of_jobs = number_of_jobs_found(city, keyword)
    current_page = page_with_search_results(city, keyword)
    while current_page != nil
      parse_short_job_advert(current_page, company, date, ip)
      next_page = current_page.link_with(:text => "Next »")
      next_page.nil? ? current_page = nil : current_page = next_page.click
      return @job_posts if @job_posts.length >= 20
    end
    @job_posts
  end

  private

  def company_ratings(company, ip)
    profiler = CompanyProfiler.new(company, ip)
    profiler.get_ratings
  end

  def page_with_search_results(city, keyword)
    agent = Mechanize.new { |agt| agt.user_agent_alias = 'Mac Firefox' }
    agent.history_added = Proc.new { sleep 0.3 }
    agent.get("https:\/\/ie.indeed.com\/jobs\?q=#{keyword}&l=#{city}")
  end

  def number_of_jobs_found(city, keyword)
    results = page_with_search_results(city, keyword)
    results = results.search('div#searchCount').children.text
    results == "" ? 0 : results.match(/\d{1,3}$/)[0].to_i
  end

  def parse_short_job_advert(page, company, date, ip)
    searched_company = company.split.map {|w| w.capitalize}.join(" ")
    page.search('div.row.result').each do |advert|
      current_company = get_job_company_name(advert)
      if (current_company.include? searched_company) && Date.strptime(date) < Date.strptime(posting_date(advert))
        array = scrapping_data_from(advert)
        array << company_ratings(current_company, ip)
        @job_posts << array
      end
    end
  end

  def scrapping_data_from(advert)
      job_description = []
      job_description << get_job_title(advert)
      job_description << get_job_company_name(advert)
      job_description << get_location(advert)
      job_description << posting_date(advert)
      job_description << get_posting_link(advert)
      job_description
  end

  def get_job_title(node)
    node.css("a")[0]["title"]
  end

  def get_job_company_name(node)
    node.css('span.company').first.text.strip
  end

  def get_posting_link(node)
    "http://www.indeed.ie" + node.css('a')[0]["href"]
  end

  def get_location(node)
    node.css('span.location').first.text.strip
  end

  def posting_date(node)
    if node.css('span.date').any?
      date = node.css('span.date').first.text
      date = date.match(/\d/)[0].to_i
      t = Time.now - date*24*60*60
      t.strftime "%Y-%m-%d"
    else
      ((Time.now).strftime "%Y-%m-%d")
    end
  end


end

end