require 'yaml'
class JobSaver
  def initialize(jobs)
    @jobs = jobs
  end

  def save(query, location)
    File.open("#{query}-#{location}", 'w') do |file|
      file.write YAML.dump(@jobs)
    end
  end

  def self.load(query, location)
    return false unless File.exist?("#{query}-#{location}")
    YAML.load(File.read("#{query}-#{location}"))
  end
end
