require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry-byebug' if development?

class DiceSearcher
  attr_reader :results
  def initialize(opts={})
    @results = []
    unless opts.empty?
      self.search(opts)
    end
  end

  def search(opts={})
    run_search(opts)
    parse_results
  end

  def run_search(opts)
    for_one = opts['for_one'] ? opts['for_one'] : ''
    for_all = opts['for_all'] ? opts['for_all'] : ''
    for_exact = opts['for_exact'] ? opts['for_exact'] : ''
    for_none = opts['for_none'] ? opts['for_none'] : ''
    for_jt = opts['for_jt'] ? opts['for_jt'] : ''
    for_com = opts['for_com'] ? opts['for_com'] : ''
    for_loc = opts['for_loc'] ? opts['for_loc'] : ''
    radius = opts['radius'] ? opts['radius'] : ''
    jtype = opts['jtype'] ? opts['jtype'] : ''
    posteddate = opts['one'] ? opts['one'] : '30'
    sort = opts['sort'] ? opts['sort'] : 'relevance'
    telecommute = opts['telecommute'] ? opts['telecommute'] : ''
    limit = opts['limit'] ? opts['limit'] : '30'
    m = Mechanize.new
    @page = m.get("https://www.dice.com/jobs/advancedResult.html?for_one=#{for_one}&for_all=#{for_all}&for_exact=#{for_exact}&for_none=#{for_none}&for_jt=#{for_jt}&for_com=#{for_com}&for_loc=#{for_loc}&jtype=#{jtype}&limit=#{limit}&telecommute=#{telecommute}&radius=#{radius}&postedDate=#{posteddate}&sort=#{sort}")
  end

  def parse_results
    results = @page.search('div.complete-serp-result-div')
    unless results.empty?
      results.each_with_index do |result, i|
        r = Result.new
        r.title = title(result)
        r.company = company(result)
        r.location = location(result)
        r.date = date(result)
        r.companyid = company_id(result, i)
        r.jobid = job_id(result, i)
        r.link = link(result)
        @results << r
      end
    end
  end

  def title(result)
    result.search("ul.list-inline li h3 a")[0][:title]
  end

  def company(result)
    result.search("ul.details li.employer a")[0].text
  end

  def location(result)
    result.search("ul.details li.location")[0][:title]
  end

  def date(result)
    date = result.search('ul.details li.posted')[0].text
    convert_date(date).strftime("%a,  %e %b %Y,  %l:%M %p")
  end

  def company_id(result, i)
    result.search('ul.list-inline li h3 a')[0][:href].match(/dice.com\/jobs\/detail\/.*\/(.*)\//)[1] if result.search('ul.list-inline li h3 a')[0][:href].match(/dice.com\/jobs\/detail\/.*\/(.*)\//)
  end

  def job_id(result, i)
    result.search('ul.list-inline li h3 a')[0][:href].match(/dice.com\/jobs\/detail\/.*\/.*\/(.*)?\?/)[1] if result.search('ul.list-inline li h3 a')[0][:href].match(/dice.com\/jobs\/detail\/.*\/.*\/(.*)?\?/)
  end

  def link(result)
    result.search("ul.list-inline li h3 a")[0][:href]
  end

  def convert_date(date)
    # xx hours ago
    if d = date.match(/(.*?)hour(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 )
      # xx days ago
    elsif d = date.match(/(.*?)day(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 * 24 )
    elsif d = date.match(/(.*?)week(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 * 24 * 7)
    elsif d = date.match(/(.*?)minute(s?) ago/)
      return Time.new - (d[1].to_i * 60)
    end

  end
end
