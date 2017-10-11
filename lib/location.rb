class Location
  include HTTParty

  base_uri 'freegeoip.net/json/'

  def self.location_for(ip_address)
    get("/#{ip_address}").to_hash
  end
end
