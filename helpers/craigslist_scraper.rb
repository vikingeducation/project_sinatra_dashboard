require 'mechanize'

class CraigslistScraper
  attr_reader :search_page, :scraper, :results_page
  def initialize(min_price, max_price, keywords)
    @scraper = Mechanize.new
    @scraper.history_added = Proc.new { sleep 0.5 }
    @search_page = scraper.get('http://sfbay.craigslist.org/search/apa')
    form = search_page.forms[1]
    form["minAsk"] = min_price
    form["maxAsk"] = max_price
    form["query"] = keywords
    @results_page = scraper.submit(form)
    @results_nodes = @results_page.search("div.content p.row")
  end

  # def get_postings
  #   (0..99).each_with_object([]) do |posting, classfield|
  # end

  def get_name(posting)
    @results_nodes[posting].search("span.pl a").text.strip
  end

  def get_url(posting)
    "http://sfbay.craigslist.org" + @results_nodes[posting].search("a.i").first[:href]
  end

  def get_price
    # @results_nodes[posting].search("span.pl a").text.strip
  end

  def get_location
    # @results_nodes[posting].search("span.pl a").text.strip
  end

  def get_email
  end
end