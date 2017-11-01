class Job
  attr_accessor :title, :job_id, :description_url, :company, :company_id, :location, :description, :date_posted, :salary, :skills, :remote
  def initialize
    @title = ''
    @job_id = ''
    @description_url = ''
    @company = ''
    @company_id =''
    @location = ''
    @description = ''
    @date_posted = ''
    @salary = ''
    @skills = ''
    @remote = ''
  end

  def add_placeholder_info
    @title = 'Super Amazing Job'
    @job_id = '123'
    @description_url = 'http://www.google.com'
    @company = 'JazzHandRama'
    @company_id ='254'
    @location = 'Omaha'
    @description = 'super job with fantastic happiness'
    @date_posted = 'October Teenth'
    @salary = '10,000,000'
    @skills = 'ruby'
    @remote = true
  end

end