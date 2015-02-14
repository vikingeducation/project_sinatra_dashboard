require 'mechanize'

class CraigslistScraper
  attr_reader :search_page, :scraper
  def initialize(min_price, max_price, keywords)
    @scraper = Mechanize.new
    @scraper.history_added = Proc.new { sleep 0.5 }
    @search_page = scraper.get('http://sfbay.craigslist.org/search/apa')
    form = search_page.forms[1]
    form["minAsk"] = min_price
    form["maxAsk"] = max_price
    form["query"] = keywords
    @results_page = scraper.submit(form)
  end
end