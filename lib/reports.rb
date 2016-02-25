# Use jobs yaml & Connected to generate a report
class Reports
  require 'yaml'
  require_relative 'status'

  attr_accessor :version, :jtype

  def gather
    @tagline                  = 'lastBuild/api/json'
    this_convert              = Reports.new
    this_convert.version      = @version
    this_convert.jtype        = @jtype
    @jobs                     = this_convert.jenkins_converter
    fin_report                = Status.new
    fin_report.tagline        = @tagline
    fin_report.jobs           = @jobs
    this_report               = fin_report.jenkins_status
    this_report['version']    = "#{@version}"
    this_report
  end
  def jenkins_converter
    @jobs         = {}
    static_djobs  = YAML.load_file('urls/jobs.yaml')
    static_djobs.each do |fkey, fvalue|
      @converted  = fvalue.to_s
      @converted  = @converted.gsub('_version_', "_#{@version}_")
      # Jenkins is case insensitive. Some Jobs are E.G. "Deploy"
      if fkey == 'PROS' && @jtype == 'deploy'
        @converted = @converted.gsub('jtype', "#{@jtype}_TRIGGER")
      else
        @converted = @converted.gsub('jtype', "#{@jtype}")
      end
      @jobs[fkey]  = "#{@converted}"
    end
    return @jobs
  end
end
