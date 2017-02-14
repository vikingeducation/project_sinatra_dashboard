
require 'rubygems'
require 'mechanize'

module JobScrapper

class WebScrapper

  def initialize
    @job_posts = []
  end

  def parse_all_job_adverts(city= "Galway", keyword = "ruby", company = "", date)
    date == "" ? date = ((Time.now - 100*24*60*60).strftime "%Y-%m-%d") : date
    1.upto(number_of_jobs_found(city, keyword)/10) do |i|
      current_page = page_with_search_results(city, keyword)
      parse_short_job_advert(current_page, company, date)
    end
    @job_posts
  end

  private

  def page_with_search_results(city, keyword, page_no = 1)
    agent = Mechanize.new { |agt| agt.user_agent_alias = 'Mac Firefox' }
    agent.history_added = Proc.new { sleep 0.5 }
    indeed_page = "https:\/\/ie.indeed.com\/jobs\?q=#{keyword}&l=#{city}&start=#{(page_no-1)*10}"
    page = agent.get(indeed_page)
    page
  end

  def number_of_jobs_found(city, keyword)
    results = page_with_search_results(city, keyword)
    results = results.search('div#searchCount').children.text
    results.match(/\d{1,3}$/)[0].to_i
  end

  def parse_short_job_advert(page, company, date)
    company = company.split.map {|w| w.capitalize}.join(" ")
    page.search('div.row.result').each do |advert|
      if (get_job_company_name(advert).include? company) && Date.strptime(date) < Date.strptime(posting_date(advert))
        array = scrapping_data_from(advert)
        puts "DBG: array = #{array.inspect}"
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
      "n\/a"
    end
  end


end

end