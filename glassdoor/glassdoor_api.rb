require 'httparty'
require 'json'

# For better debugging
require 'pp'

class Glassdoor
  API_KEY = ENV["API_KEY"]
=begin
  Parameters

  Parameter   Explanation   Required?
  1. v The API version. The current version is 1 except for jobs, which is currently version 1.1 Yes
  format  Either xml or json as you prefer  Yes (DONE)
  2. t.p Your partner id, as assigned by Glassdoor Yes (DONE)
  3. t.k Your partner key, as assigned by Glassdoor  Yes (Will call in when calling app - considering it's a required class, I should just be able to do - rerun API_KEY ruby app.rb or whatever the order is)
  4. userip  The IP address of the end user to whom the API results will be shown  Yes !!!!!!!!!!
  5. useragent The User-Agent (browser) of the end user to whom the API results will be shown. Note that you can can obtain this from the "User-Agent" HTTP request header from the end-user Yes !!!!!!!
  6. callback  If json is the requested format, you may specify a jsonp callback here, allowing you to make cross-domain calls to the glassdoor API from your client-side javascript. See the JSONP wikipedia entry for more information on jsonp. No (DONE)
  7. action  Must be set to employers  Yes (DONE)
  8. q Query phrase to search for - can be any combination of employer or occupation, but location should be in l param. No (DONE)
  9. l Scope the search to a specific location by specifying it here - city, state, or country.  No (DONE)
  10. city  Scope the search to a specific city by specifying it here.  No (DONE)
  11. state Scope the search to a specific state by specifying it here. No (DONE) !!!!!!!!!! LOCATION!!!
  12. country Scope the search to a specific country by specifying it here. No (DONE)
  13. pn  Page number to retrieve. Default is 1.  No (DONE)
  14. ps  Page size, i.e. the number of jobs returned on each page of results. Default is 20. No (DONE)
=end

  BASE_URI = "http://api.glassdoor.com/api/api.htm?"

  # Construct and initiate the new request
  def get_employer_details(user_ip, user_agent, company_name, country)

    # Build our URL
    uri = "#{BASE_URI}t.p=55204&t.k=#{API_KEY}&userip=#{user_ip}&useragent=#{user_agent}&format=json&v=1&action=employers&q=#{company_name}&l=#{country}"

    # Build the request
    request = HTTParty.get(uri)
  end
end
