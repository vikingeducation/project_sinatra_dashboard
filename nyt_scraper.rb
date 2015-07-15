require 'httparty'
require 'date'

class NewYorkTimesScraper

  if File.exist?("keys.txt")
    @@key = File.readlines("keys.txt")[2].strip
  else
    @@key = ENV['NYT_KEY']
  end

  def initalize
    @target_date = (DateTime.now - 90).strftime("%Y%m%d").to_s
  end

  def get_articles(query)
    query = query.gsub(" ", "+").gsub(",", "%2C")
    results = HTTParty.get("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=#{query}&end_date=#{(DateTime.now - 90).strftime("%Y%m%d").to_s}&f1=headline&api-key=#{@@key}")
    p results["response"]["docs"]
    articles = []
    if results["response"] && results["response"]["docs"].length > 0
      results["response"]["docs"].each do |doc|
        data = {}
        data[:web_url] = doc["web_url"]
        data[:headline] = doc["headline"]["main"]
        articles << data
      end
    else
      return nil
    end

    return articles
  end

end