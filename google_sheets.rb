require "google/api_client"
require "google_drive"
require 'envyable'

Envyable.load('config/env.yml')

class GoogleSheets

  def initialize(file)
    client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = ENV["google_ID"]
    auth.client_secret = ENV["google_secret"]
    auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/"
    ]
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    auth.refresh_token = ENV["google_refresh_token"]
    auth.fetch_access_token!(:connection => client.connection)
    @access_token = auth.access_token
    @sheet = ENV["#{file}_sheet"]
  end


  def load_sheet
    session = GoogleDrive.login_with_oauth(@access_token)
    session.spreadsheet_by_key(@sheet).worksheets[0]
  end


  def load_company_profile(company_id)
    session = GoogleDrive.login_with_oauth(@access_token)
    rows = session.spreadsheet_by_key(@sheet).worksheets[0].list   
    rows.each do |row|
      
    end
  end
  
  
end