require 'httparty'

class GlassDoorScraper
  @@id = File.readlines("keys.txt")[0].strip
  @@key = File.readlines("keys.txt")[1].strip

  def initialize
    @base_url = "http://api.glassdoor.com/api/api.htm?t.p=#{@@id}&t.k=#{@@key}&useragent=Mozilla/%2F4.0&format=json&v=1"
  end

  def get_employer(employer_name, ip)
    url = formatted_url(employer_name, ip)
    results = HTTParty.get(url)

    info = Hash.new(nil)

    if results["response"]["employers"].length > 0
      results = results["response"]["employers"][0]
    else
      return nil
    end

    info[:website] = results["website"]
    info[:rating] = results["overallRating"]
    if results["featuredReview"]
      info[:pros] = results["featuredReview"]["pros"]
      info[:cons] = results["featuredReview"]["cons"]
    end

    if results["ceo"]
      info[:ceo] = results["ceo"]["name"]
      info[:ceo_rating] = results["ceo"]["pctApprove"]
    end



    return info
  end

  def formatted_url(employer_name, ip)
    employer_name = employer_name.gsub(" ", "+").gsub(",", "%2C")
    return @base_url + "&q=#{employer_name}" + "&userip=#{ip}" + "&action=employers"
  end
end