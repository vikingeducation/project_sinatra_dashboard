class JobScraper

  attr_reader :first_page, :scraper

  SECONDS_IN_HOUR = 60 ** 2
  SECONDS_IN_DAY = SECONDS_IN_HOUR * 24 
  SECONDS_IN_WEEK = SECONDS_IN_DAY * 7
  SECONDS_IN_MONTH = SECONDS_IN_DAY * 30

  def initialize(query, location)
    @scraper = Mechanize.new
    @url_query = query.gsub(" ", "+")
    @location_url = location.gsub(/[\s,]/, "\s" => "+", "," => "%2C")
    @first_page = @scraper.get("https://www.dice.com/jobs?q=#{@url_query}&l=#{@location_url}")
    @current_page = @first_page
    @scraper.history_added = Proc.new { sleep 0.5 }
  end

  def get_pages
    pages = []
    count = 1
    until job_posts(@current_page).empty?
      pages << @current_page
      count += 1
      next_page(count)
    end
    pages
  end

  def job_details
    details = []
    get_pages.each do |page|
      job_postings = job_posts(page)
      job_count = job_posts(page).count
      job_count.times do |i| 
        details << [job_title(job_postings, i), 
                    company_name(job_postings, i), 
                    job_link(job_postings, i), 
                    job_location(job_postings, i), 
                    post_date(job_postings, i)
                    ]
      end
    end
    details
  end

  def next_page(page_num)
    query = @url_query.gsub("+", "_")
    location = @location_url.gsub("+", "_")
    @current_page = @scraper.get("https://www.dice.com/jobs/q-#{query}-l-#{location}-startPage-#{page_num}-jobs")    
  end

  def job_posts(page)
    page.search("#serp div.complete-serp-result-div div.serp-result-content")
  end

  def job_title(posts, idx)
    posts.search("h3 a")[idx].attributes["title"].value
  end

  def company_name(posts, idx)
    posts.search("li.employer a")[idx].children.text
  end

  def job_link(posts, idx)
    posts.search("h3 a")[idx].attributes["href"].value
  end

  def job_location(posts, idx)
    posts.search("li.location")[idx].attributes["title"].value
  end

  def post_date(posts, idx)
    time_description = posts.search("li.posted")[idx].text
    time_unit = time_description.split(" ")[1]
    time_unit += "s" unless time_unit[-1] == "s"
    unit_num = time_description.split(" ")[0].to_i
    to_seconds = { "minutes" => unit_num * 60, 
                  "hours" => unit_num * SECONDS_IN_HOUR,
                  "days" => unit_num * SECONDS_IN_DAY, 
                  "weeks" => unit_num * SECONDS_IN_WEEK, 
                  "months" => unit_num * SECONDS_IN_MONTH }
    time_passed = to_seconds[time_unit]             
    date_posted = Time.now - time_passed unless time_passed.nil?
    "#{date_posted.month}/#{date_posted.day}/#{date_posted.year}"
  end

end
