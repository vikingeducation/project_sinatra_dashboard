require 'mechanize'
require_relative 'posting'

class CraigslistScraper
  attr_reader :search_page, :scraper, :results_page, :postings

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
    @postings = get_postings
    append_emails
  end

  def render
    @postings.inject("") do |html, post|
      html += "<tr><td>#{post.name}</td><td>#{post.price}</td><td>#{post.location}</td><td><a href='#{post.url}'>link</a></td>"
      html += "<td>#{post.email}</td>" if post.email
      html += "</tr>"
    end
  end

  def get_postings
    (0..(@results_nodes.count-1)).each_with_object([]) do |posting, classified|
      classified << Posting.new(get_name(posting),
                                get_url(posting),
                                get_price(posting),
                                get_location(posting))
    end
  end

  def get_name(posting)
    @results_nodes[posting].search("span.pl a").text.strip
  end

  def get_url(posting)
    "http://sfbay.craigslist.org" + @results_nodes[posting].search("a.i").first[:href]
  end

  def get_price(posting)
    @results_nodes[posting].search("span.price").text.strip
  end

  def get_location(posting)
    begin
      with_parens = @results_nodes[posting].search("span.pnr small").text.strip
      with_parens[1..-2]
    rescue
      nil
    end
  end

  def append_emails
    @postings[0..9].each do |posting|
      post_number = /\/(\d+).html$/.match(posting.url)[1]
      reply_page = scraper.get("http://sfbay.craigslist.org/reply/" + post_number)
      begin
      posting.email = reply_page.search(".mailapp").text
      rescue
      end
    end
  end
end