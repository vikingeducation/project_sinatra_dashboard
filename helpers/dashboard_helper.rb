module DashboardHelper
  def load_query
    session[:query] = [].to_json if session[:query].nil?
  end

  def save_query(job_query)
    session[:query] = job_query["resultItemList"].to_json
  end

  def render_information(job_query)
    table_rows = ""
    JSON.parse(job_query).each do |job|
      table_rows += "<tr><td>#{job["jobTitle"]}</td><td>#{job["company"]}</td><td>#{job["location"]}</td><td>#{job["date"]}</td><td><a href=\"#{job["detailUrl"]}\">link</a></td></tr>"
    end
    table_rows
  end

end