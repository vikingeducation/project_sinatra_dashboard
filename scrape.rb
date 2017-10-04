require 'mechanize'
require 'csv'

class DiceScraper

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.9 }
    @info_array = []
    @url = ""
    @page_num = 1
  end

  def search_jobs(query, location, duration=1000)
    @duration = duration
    @url = formatted_url(query, location)
    parse_page(nav_url)
    return @info_array
    #append_to_file(@info_array)
  end


  def formatted_url(query, location)
    query = query.gsub(" ", "+").gsub(",", "%2C")
    location = location.gsub(" ", "+").gsub(",", "%2C")
    return "https://www.dice.com/jobs/q-#{query}-l-#{location}-radius-5-sort-date-limit-120"
  end

  def nav_url
    return @url + "-startPage-#{@page_num}-jobs"
  end

  def parse_page(url)
    page = @agent.get(url)

    # Search the page for any results
    listings = page.search(".serp-result-content")

    inside_duration = true
    @page_num = 1
    # While there are results on the page (and they aren't too old)
    while (page.search(".serp-result-content").search('.dice-btn-link').any? && inside_duration)
      p "Getting url #{nav_url}"
      listings.each do |listing|

        info = generate_info(listing)
        if (DateTime.now - @duration) > info[:date]
          inside_duration = false
          break
        end
        @info_array << info unless @info_array.any? {|row| row[:jid] == info[:jid]}
      end
      @page_num += 1

      page = @agent.get(nav_url)
      listings = page.search(".serp-result-content")
    end
  end

  def generate_info(listing)
    info = {}
    info[:title] = listing.search('.dice-btn-link')[0].inner_text.strip
    info[:link] = listing.search('.dice-btn-link')[0]["href"]
    info[:jid] = get_jid(info[:link])
    info[:cname] = listing.search('.dice-btn-link')[1].inner_text.strip
    info[:cid] = get_cid(listing.search('.dice-btn-link')[1]["href"])
    info[:loc] = listing.search('.location')[0].inner_text.strip
    info[:date] = get_post_date(listing.search('.posted')[0].inner_text.strip)
    return info
  end

  def get_cid(url)
    url.split("/")[-1]
  end

  def get_jid(url)
    url.match(/\/([%\w\d-]*)[?]/)[1]
  end

  def get_post_date(relative_time_str)
    offsets = {"day" => 1, "days" => 1,
               "week" => 7, "weeks" => 7,
               "month" => 30, "months" => 30,
               "year" => 365, "years" => 365}
    relative_time_str = relative_time_str.split(" ")
    multiplier = relative_time_str[0].to_i
    duration = offsets[relative_time_str[1].downcase]
    duration = 0 if duration.nil?

    return (DateTime.now - (multiplier * duration)).to_datetime
  end

  def append_to_file(info)
    CSV.open("results.csv", "w") do |file|
      info.each do |entry|
        file << [entry[:title],
                 entry[:cname],
                 entry[:link],
                 entry[:loc],
                 entry[:date].strftime("%B %d, %Y"),
                 entry[:cid],
                 entry[:jid]]
      end
    end
  end
end