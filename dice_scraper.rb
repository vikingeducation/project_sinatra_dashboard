class DiceScraper

  require 'bundler/setup'
  require 'mechanize'
  require 'csv'

  require './locator.rb'
  require './company_profiler.rb'

  BASE_URL = "https://www.dice.com/jobs"


  def initialize
    @agent = Mechanize.new
    @profiler = CompanyProfiler.new
  end


  def search(location)
    params = {}

    params[:'search-text'] = "web developer"
    params[:'search-location'] = location
    params[:'start_date'] = Date.today

    search_with_params(params)
  end


  def search_with_params(params, location)
    params[:'search-text'] = "web developer" if params[:'search-text'].nil? || params[:'search-text'].empty?
    params[:'search-location'] = location if params[:'search-location'].nil? || params[:'search-location'].empty?
    params[:'start-date'] = Date.today if params[:'start-date'].nil? || params[:'start-date'].empty?

    run_search(params)
  end


  private


  def get_search_form
    page = @agent.get(BASE_URL)

    page.form_with(:id => 'searchJob')
  end


  def run_search(params)
    search_text = params[:'search-text']
    search_location = params[:'search-location']
    start_date = params[:'start-date']

    start_date = Date.strptime(start_date) if start_date.is_a?(String)

    search_form = get_search_form

    search_form.q = search_text
    search_form.l = search_location

    response = @agent.submit(search_form)

    job_list = scrape_jobs( sort_by_date( response ) )

    query = [search_text, search_location, start_date.to_s]
    results = []




    job_list[0..9].each_entry do |job| # limit to first 10 jobs for testing
      result = scrape_details(job, start_date)

      unless result.nil?
        final_result = append_profile(result)
        results << final_result
      end

      sleep 0.5
    end

    [query, results]

  end


  def sort_by_date(results_page)
    response_url = results_page.uri.to_s
    sorted_url = response_url + "&sort=date"
    @agent.get(sorted_url)
  end


  def scrape_jobs(results_page)
    results_page.search("#search-results-control .serp-result-content")
  end


  def scrape_details(job, start_date)
    posted_text = job.at_css("li.posted").text

    post_date = calc_date(posted_text)
    return if post_date < start_date

    job_title = job.at_css("h3 a").text.strip
    company = job.at_css("li.employer").text
    link = job.at_css("h3 a").attributes["href"].value
    location = job.at_css("li.location").text

    id_numbers = find_id_numbers(link)

    job_details = { title: job_title,
                    company: company,
                    link: link,
                    location: location,
                    date: post_date.to_s,
                    co_id: id_numbers[1],
                    job_id: id_numbers[2]
                  }

    job_details
    # save_to_csv(job_details)

  end


  def calc_date(posted_text)

    parse_time = posted_text.match(/(\d.*?)\s(.*?)s?\s/i)

    hours_since_post = calc_hours(parse_time)

    (Time.now - hours_since_post*60*60).to_date
  end


  def calc_hours(time_since_post)

    time_in_hours = { minute: 0,
                      hour: 1,
                      day: 24,
                      week: 168,
                      month: 720
                    }

    if time_since_post.nil?
      hours = 0
    else
      hours = time_since_post[1].to_i * time_in_hours[time_since_post[2].downcase.to_sym]
    end

    hours

  end


  def find_id_numbers(url)
    ids = url.match(/dice.com(?:\/.*?){3}\/(.*?)\/(.*?)\?/)
    ids ||= Array.new(3)
    ids
  end


  def append_profile(dice_result)
    final_result = dice_result.dup

    profile = @profiler.get_profile(dice_result[:company])

    #final_result[:GD_name] = profile[:name]
    final_result[:ratings] = profile[:ratings]
    final_result[:review] = profile[:review]

    final_result
  end


  def save_to_csv(job_details)

    CSV.open('results.csv', 'a') do |csv|

        csv <<  [ job_details[:title],
                  job_details[:company],
                  job_details[:link],
                  job_details[:location],
                  job_details[:date],
                  job_details[:co_id],
                  job_details[:job_id]
                ]
    end

  end

end