module Scraper

  require "mechanize"
  require "csv"
  require "pry"

  class DiceScraper

    def initialize(job_title = "ruby on rails", location = "raleigh",year = 2015, month = 01, day = 01)

      @start_date = Time.new(year, month, day)
      @agent = Mechanize.new
      @agent.history_added = Proc.new { sleep 0.5 }
      @job_title = job_title.split(" ").join("+")
      @location = location.split(" ").join("%2C+")

    end

    def calculate_date(time)
      arr = time.split(" ")
      time_value = arr[0].to_i
      period = arr[1]

      period_in_seconds = 0

      if period.include?("second")
        period_in_seconds = time_value
      elsif period.include?("minute")
        period_in_seconds = time_value * 60
      elsif period.include?("hour")
        period_in_seconds = time_value * 60 * 60
      elsif period.include?("day")
        period_in_seconds = time_value * 60 * 60 * 24
      elsif period.include?("week")
        period_in_seconds = time_value * 60 * 60 * 24 * 7
      elsif period.include?("month")
        period_in_seconds = time_value * 60 * 60 * 24 * 7 * 30
      elsif period.include?("year")
        period_in_seconds = time_value * 60 * 60 * 24 * 7 * 30 * 12
      end

      current_time = Time.now
      @post_time = current_time - period_in_seconds

      "#{@post_time.month}/#{@post_time.day}/#{@post_time.year}"

    end

    def scrape

      page_count = 1
      @post_time = Time.now
      array = []

      array << ["Title", "Company Name", "Link", "Location",
        "Post Date", "Dice ID", "Job ID"]

      until @start_date > @post_time

        job_postings = initialize_page(generate_url(page_count))

        job_postings.each do |job_post|

          job_details = get_job_details(job_post)
          array << job_details if @post_time > @start_date

        end

        page_count += 1
        break if page_count > 5

      end

      array

    end

    def scrape_indeed

      page_count = 1
      @post_time = Time.now
      added_jobs = []

      CSV.open('job_list.csv', 'a') do |csv|

        csv << ["Title", "Company Name", "Link", "Location",
        "Post Date", "Indeed ID"]

        until @start_date > @post_time

          job_postings = initialize_indeed_page(generate_indeed_url(page_count))

          job_postings.each do |job_post|

            job_details = get_indeed_details(job_post)

            unless added_jobs.include?(job_details[-1])

              csv << job_details if @post_time > @start_date

              added_jobs << job_details[-1]

            end

          end

          page_count += 1
          break if page_count > 50

        end

      end

    end

    def get_indeed_details(job_element)

      path = job_element.at_css("h2 a").attributes["href"].value
      job_link = "http://www.indeed.com#{path}"
      job_title = job_element.at_css("h2").text.strip
      company_name = job_element.at_css("span[@itemprop = name]").text
      job_location = job_element.at_css("span[@itemprop = addressLocality]").text
      formatted_time = calculate_date(job_element.at_css("span[@class = date]").text)

      [ job_title, company_name, job_link, job_location,
        formatted_time, path,
      ]

    end

    def generate_url(page_num)
      "https://www.dice.com/jobs/q-#{@job_title}-sort-date-l-#{@location}-radius-30-startPage-#{page_num}-limit-120-jobs.html"
    end

    def initialize_page(url)
      page = @agent.get(url)
      page.search("div[@class='serp-result-content']")

    end

    def initialize_indeed_page(url)
      page = @agent.get(url)
      page.search("div[@class='  row  result']")
    end

    def get_job_details(job_element)

      job_link = job_element.at_css("h3 a").attributes["href"].value
      job_title = job_element.at_css("h3").text.strip
      company_name = job_element.at_css("li[@class = employer]").text
      job_location = job_element.at_css("li[@class = location]").text
      formatted_time = calculate_date(job_element.at_css("li[@class = posted]").text)
      link_array = job_link.split("/")
      job_company_id = link_array[6]
      post_id = link_array[7].split("?")[0]

      [ job_title, company_name, job_link, job_location,
        formatted_time, job_company_id, post_id
      ]

    end

    def generate_indeed_url(count_start)
      "http://www.indeed.com/jobs?q=ruby&start=#{(count_start * 10) - 10}"
    end
  end
end