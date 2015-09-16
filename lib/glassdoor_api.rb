require 'httparty'
require 'uri'

class GlassdoorAPI
	END_POINT = 'http://api.glassdoor.com/api/api.htm'
	VERSION = 1
	FORMAT = 'json'
	ACTION = 'employers'

	attr_reader :data

	def initialize(options={})
		@id = options[:id]
		@key = options[:key]
		@ip = options[:ip]
		@user_agent = options[:user_agent]
	end

	def search(q, l)
		url = build_url(q, l)
		response = HTTParty.get(url)
		success = response.code == 200
		@data = []
		if success
			employers = response['response']['employers']
			employers.each do |e|
				employer = {}
				employer[:id] = e['id']
				employer[:name] = e['name']
				employer[:website] = e['website']
				employer[:industry] = e['industry']
				employer[:num_ratings] = e['numberOfRatings']
				employer[:image] = e['squareLogo']
				employer[:overall_rating] = e['overallRating']
				employer[:rating_description] = e['ratingDescription']
				employer[:culture_values_rating] = e['cultureAndValuesRating']
				employer[:leadership_rating] = e['seniorLeadershipRating']
				employer[:compensation_rating] = e['compensationAndBenefitsRating']
				employer[:opportunity_rating] = e['careerOpportunitiesRating']
				employer[:work_balance_rating] = e['workLifeBalanceRating']
				employer[:recommendation_rating] = e['recommendToFriendRating']
				if e['featuredReview']
					r = e['featuredReview']
					employer[:has_review] = true
					review = {}
					review[:id] = r['id']
					review[:current_job] = r['currentJob']
					review[:job_title] = r['jobTitle']
					review[:location] = r['location']
					review[:headline] = r['headline']
					review[:pros] = r['pros']
					review[:cons] = r['cons']
					review[:rating] = r['overall']
					review[:rating_numeric] = r['overallNumeric']
					employer[:review] = review
				end
				if e['ceo']
					c = e['ceo']
					ceo = {}
					ceo[:name] = c['name']
					ceo[:title] = c['title']
					ceo[:num_ratings] = c['numberOfRatings']
					ceo[:percent_approval] = c['pctApprove']
					ceo[:percent_disapproval] = c['pctDisapprove']
					ceo[:image] = c['image']['src'] if c['image']
					employer[:ceo] = ceo
				end
				@data << employer
			end
		end
		success
	end

	private
		def build_url(q, l)
			query = build_query(q, l)
			"#{END_POINT}?#{query}"
		end

		def build_query(q, l)
			query = []
			[
				['v', VERSION],
				['format', FORMAT],
				['action', ACTION],
				['t.p', @id],
				['t.k', @key],
				['ip', @ip],
				['useragent', @user_agent],
				['q', q],
				['l', l]
			].each do |param|
				query << URI::encode(param.join('='))
			end
			query.join('&')
		end
end