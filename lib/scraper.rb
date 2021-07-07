require 'mechanize'

class Scraper
	attr_accessor :task, :data

	def initialize(options={})
		@task = options[:task]
		@data = {}
		@agent = Mechanize.new
		@agent.history_added = Proc.new {sleep 1}
	end

	def scrape
		@data = @task.run(@agent)
	end
end