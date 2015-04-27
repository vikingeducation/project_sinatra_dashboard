require 'mechanize'

Listing = Struct.new(:name, :link, :email, :price, :location)

class CraigScraper
  def initialize(min_ask, max_ask, keywords)
    @listings = []
    @scraper = Mechanize.new
    # @scraper.history_added = proc { sleep 0.5 }
    @min = min_ask
    @max = max_ask
    @keywords = keywords
  end

  def form_submit
    @scraper.get('http://sfbay.craigslist.org/apa') do |page|
      form = page.forms[1]
      form['minAsk'] = @min
      form['maxAsk'] = @max
      form['query'] = @keywords
      @results_page = form.submit
    end # performing the search from the apts/housing page
  end

  def fetch_emails
    @listings.each do |listing|
      listing_id = /\/(\d+).html$/.match(listing.link)[1]
      email_page = @scraper.get('http://sfbay.craigslist.org/reply/' + listing_id)
      listing.email = email_page.search('.mailapp').text.strip
    end
  end

  def listings
    form_submit

    @results_page.links_with(href: %r{\/.{3}\/apa}).each do |link|

      next if link.text == ''

      current_listing = Listing.new

      current_listing.name = link.text.strip
      current_listing.link = 'http://sfbay.craigslist.org' + link.uri.to_s

      description_page = link.click

      current_listing.price = description_page.search('.price').text.strip
      current_listing.location = description_page.search('//*[@id="pagecontainer"]/section/h2/span[2]/small').text.gsub("(", "").gsub(")", "").strip

      @listings << current_listing
    end
    fetch_emails
  end

  def table_render
    code = ''
    @listings.each do |listing|
      code += '<tr>'
      code += "<td>#{listing.name}</td>"
      code += "<td><a href='#{listing.link}'>#{listing.link}</a></td>"
      code += "<td><a href='mailto:#{listing.email}'>#{listing.email}</a></td>" if listing.email
      code += "<td>#{listing.price}</td>"
      code += "<td>#{listing.location}</td>"
      code += '<tr>'
    end
    code
  end
end
