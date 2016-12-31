Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class Scraper 

  attr_reader :postings

  def initialize(search_terms, location)
    results = get_results(search_terms, location)
    collect_results(results)
  end

  def make_scraper
    scraper = Mechanize.new do |scraper|
      scraper.history_added = Proc.new { sleep 0.5 }
      scraper_alias = 'Windows Chrome'
    end
  end

  def get_results(search_terms, location)
    scraper = make_scraper
    url = get_url(search_terms, location)
    page = scraper.get(url)
  end

  def get_url(search_terms, location)
    search_terms = search_terms.gsub(" ","+")
    location = location.gsub(" ","%2C+")
    "https://www.dice.com/jobs?q=#{search_terms}&l=#{location}"
  end

  def collect_results(page)
    @postings = []
    counter = 0
    page.links_with(:class => "dice-btn-link loggedInVisited").each do |link|
      @postings << scrape_info(link)
      puts link
      #for dev purposes, scraping entire page is too time-intensive
      counter += 1
      break if counter > 9
    end
  end

  # make new job object out of info on description page
  def scrape_info(link)
    description = link.click
    link = link.href
    title = get_title(description)
    company = get_company(description)
    location = get_location(description)
    date = get_date(description)
    company_id = get_company_id(description)
    job_id = get_job_id(description)
    Job.new(title, company, link, location, date, company_id, job_id)
  end

  def get_title(description)
    description.search("h1.jobTitle").text.strip
  end

  def get_company(description)
    description.search("li.employer").text.strip
  end

  def get_location(description)
    description.search("li.location").text.strip
  end

  def get_date(description)
    title = description.search("title").text
    title.match(/\d+-\d+-\d+/).to_s
  end

  def get_company_id(description)
    description.at("div.company-header-info").css("div").text.match(/Dice Id : (.+)/).captures.first
  end

  def get_job_id(description)
    description.at("div.company-header-info").css("div").text.match(/Position Id : (.+)/).captures.first
  end

end