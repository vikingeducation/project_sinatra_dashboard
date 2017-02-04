require 'httparty'
r = HTTParty.get('http://freegeoip.net/json')
p r

g = HTTParty.get('http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120398&t.k=kfcIIqo8xds&action=employers&name=fdjsklfwe')
#<HTTParty::Response:0x7fe3ab83ce58 parsed_response={"ip"=>"202.166.19.74", "country_code"=>"SG", "country_name"=>"Singapore", "region_code"=>"01", "region_name"=>"Central Singapore Community Development Council", "city"=>"Singapore", "zip_code"=>"", "time_zone"=>"Asia/Singapore", "latitude"=>1.2855, "longitude"=>103.8565, "metro_code"=>0}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"date"=>["Thu, 02 Feb 2017 13:08:10 GMT"], "content-type"=>["application/json"], "content-length"=>["269"], "vary"=>["Origin"], "x-database-date"=>["Thu, 05 Jan 2017 01:30:13 GMT"], "x-ratelimit-limit"=>["10000"], "x-ratelimit-remaining"=>["9999"], "x-ratelimit-reset"=>["3600"], "server"=>["cloudflare-nginx"], "cf-ray"=>["32addeca07ca33c1-HKG"], "connection"=>["close"]}>
