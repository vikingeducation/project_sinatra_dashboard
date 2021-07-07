require_relative 'scrape_task.rb'

class DiceTask < ScrapeTask
	END_POINT = 'https://www.dice.com/jobs/'

	attr_accessor :query, :location

	def initialize(options={})
		super(options)
		@query = options[:query]
		@location = options[:location]
		add_tasks
	end

	def dice_post_time(string)
		matches = string.match(/^posted (.*) ago$/i)
		return nil unless matches
		a = matches[1].split(' ')
		return nil unless a[1]
		number = a[0].to_i
		unit = a[1].downcase
		unit += 's' unless unit[-1] == 's'
		date = Date.today
		if ['days', 'months', 'years'].include?(unit)
			a = date.to_s.split('-')
			year = a[0].to_i
			month = a[1].to_i
			day = a[2].to_i
			case unit
			when 'years'
				year -= number
			when 'months'
				month -= number
			when 'days'
				day -= number
			end
			date = Date.new(year, month, day)
		end
		date
	end

	private
		def build_url
			"#{END_POINT}#{build_query}-jobs"
		end

		def build_query
			q = []
			[
				['q', @query],
				['l', @location],
				['radius', 30],
				['startPage', 1],
				['limit', 5]
			].each do |param|
				q << param.join('-')
			end
			q.join('-')
		end

		def add_tasks
			add(:get_page) do |agent, data|
				puts 'Getting the page'
				agent.get(build_url)
			end

			add(:get_links) do |agent, data|
				puts 'Getting the links from the page'
				page = data[:get_page]
				page.links_with(:href => /jobs\/detail/)
			end

			add(:get_jobs) do |agent, data|
				puts 'Clicking links'
				links = data[:get_links]
				data[:jobs] = [] unless data[:jobs]
				links.each_with_index do |link, i|
					puts "Link: #{i} of #{links.length}"
					result = link.click
					job = {}
					job[:title] = result.search('.jobTitle').text
					job[:company_name] = result.search('.employer').text.strip
					job[:link] = link.href
					job[:location] = result.search('.location').text
					posted = result.search('.posted').text
					date = dice_post_time(posted)
					job[:date] = date ? date.to_s : Date.today.to_s
					ids = result.search('.company-header-info').text.scan(/(.+):(.+)/)
					ids.map do |i|
						i = i.join(':').strip
						job[:company_id] = i if i.match(/dice/i)
						job[:job_id] = i if i.match(/position/i)
					end
					data[:jobs] << job
				end
			end
		end
end






