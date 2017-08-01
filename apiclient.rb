require './hidden.rb'
require 'typhoeus'
require 'httparty'
require 'json'

# http://api.glassdoor.com/api/api.htm?
# t.p=177857&t.k=c0AkCTQ8MX5&userip=72.174.9.5&
# useragent=chrome&format=json&v=1&action=employers&
# q=Crescent Solutions Inc


class APIClient

  def initialize(options={})
    @partner_id, @partner_key, @userip, @useragent, @format, @v, @action, @base_uri, @q =
    options[:partner_id], options[:partner_key], options[:userip], options[:useragent],
    options[:format], options[:v], options[:action], options[:base_uri], options[:q]
  end

  def send_request
    uri = (@base_uri + "?")
    params = { "t.p" => @partner_id,
               "t.k" => @partner_key,
               "userip" => @userip,
               "useragent" => @useragent,
               "format" => @format,
               "v" => @v,
               "action" => @action,
               "q" => @q,
             }
    request = Typhoeus::Request.new( uri,
                                     method: :get,
                                     params: params )
    request.run
    pp request.response
  end


end # end of class
