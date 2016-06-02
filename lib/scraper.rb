require_relative 'glassdoor'

class SearchJobs

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @base_uri = "http://www.dice.com"
    @company_ratings = {}
    @result = []
  end

  def get_jobs(term, location)
    @agent.get(@base_uri) do |page|

      search_form = page.form_with(:action => '/jobs') do |search|
        search.q = term
        search.l = location
      end.submit

      results = search_form.search('div#search-results-control div.serp-result-content')

      results.each do |result|
        parsed = parse_job(result)
        @result << parsed
      end
    end
    return @result
  end

  def parse_job(result)
    title = result.search('a.dice-btn-link')[0].text.strip
    employer = result.search('li.employer span.hidden-xs')[0].attributes['title'].value
    location = result.search('li.location').text.strip
    link = result.search('a.dice-btn-link')[0].attributes['href'].value
    rating = check_company(employer)
    return { title: title, employer: employer, location: location, link: link, rating: rating }
  end

  def check_company(company)
    if @company_ratings.has_key?(company)
      puts "already exists. fetching existing data."
      return @company_ratings[company]
    else
      puts "does not exist. gotta hit the API."
      @company_ratings[company] = GlassDoor.new(company).get_rating
      return @company_ratings[company]
    end
  end

end
