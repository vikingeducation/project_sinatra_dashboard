require 'httparty'
class DiceApi
  include HTTParty

  base_uri "service.dice.com/api/rest/jobsearch/v1/simple.json"

  def initialize(job=nil,state=nil,ip=nil,pgcnt=50)
    @options = {query: {text: job,ip: ip , sort: 1, direct: 1, pgcnt: pgcnt, state: state}}
  end

  def find_jobs
    self.class.get('', @options)
  end
end