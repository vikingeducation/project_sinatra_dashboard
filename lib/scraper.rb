class SearchJobs

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @base_uri = "http://www.dice.com"
    @result = []
  end

  def get_jobs(term)
    @agent.get(@base_uri) do |page|

      search_form = page.form_with(:action => '/jobs') do |search|
        search.q = term
        search.l = "Austin, TX"
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
    employer = result.search('li.employer').text.strip
    location = result.search('li.location').text.strip
    link = result.search('a.dice-btn-link')[0].attributes['href'].value
    return { title: title, employer: employer, location: location, link: link }
  end

end
