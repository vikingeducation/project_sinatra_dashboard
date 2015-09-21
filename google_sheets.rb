require "google/api_client"
require "google_drive"
require 'envyable'

Envyable.load('config/env.yml')

class GoogleSheets

  def initialize
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
    @google_sheet = ENV["google_sheet_ID"]

    @jobs = load_sheet("jobs")
    @companies = load_sheet("company_profiles")
  end


  def load_jobs
    @jobs.list.to_hash_array
  end


  def save_jobs(new_jobs)
    new_jobs.each do |job|
      @jobs.list.push(job)
    end
    @jobs.save
  end


  def existing_job_ids
    job_ids = []
    @jobs.list.each do |row|
      job_ids << row["job_id"]
    end
    job_ids
  end


  def load_company_profile(company_id)
    @companies.list.select { |row| row["company_id"] == company_id }[0]
  end


  def save_company_profile(profile)
    @companies.list.push(profile)
    @companies.save
  end


  private


  def load_sheet(sheet_name)
    session = GoogleDrive.login_with_oauth(@access_token)
    session.spreadsheet_by_key(@google_sheet).worksheet_by_title(sheet_name)
  end
  
end