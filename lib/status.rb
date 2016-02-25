# manipulate data from REST services to get status
class Status
  require_relative 'connector'
  require_relative 'decision_maker'

  attr_accessor :jobs, :tagline, :key, :value

  def jenkins_status
    # when we add models to this code use toggle!
    @human      = true
    @fin_report = {}
    @jobs.each do |key, value|
      this                = Status.new
      this.tagline        = @tagline
      this.value          = value
      status              = this.one_job
      # artifact version
      if value =~ /foo/ || value =~ /bar/
        puts "these artifacts have no version."
      else
        av                  = Status.new
        av.key              = key
        av.value            = value
        art_version         = av.artifact_status
      end
      # end artifact version
      my_results              = DecisionMaker.new
      my_results.status       = status
      my_results.human        = @human
      my_results.key          = key
      my_results.value        = value
      my_results.art_version  = art_version
      result                  = my_results.decide
      @fin_report.update(result)
      puts "updating fin_report with ... #{result}"
    end
    @fin_report
  end
  def one_job
    begin
      my_uri              = URI.parse "#{@value}#{@tagline}"
      my_report           = Connector.new
      my_report.uri       = my_uri
      status              = my_report.gather
      return status
    rescue URI::InvalidURIError
      puts "oh well, we dont like this URI"
    end
  end
  def artifact_status
    @result = String.new
    if @key == 'foo' || @key == 'bar' || @key == 'foobar' 
      ver_it1   = value.split(/_/)[2]
      @ver      = ver_it1.split(/_/)[0]
    else  
      ver_it1   = value.split(/_/)[1]
      @ver      = ver_it1.split(/_/)[0]
    end
    if @key == 'larry' 
      @key = 'larry%20moe'
    elsif @key == 'curly'
      @key = 'larry%20moe'
    end
    tagline   = "search?name=#{@key}&release=#{@ver}&human=true?"
    this                = Status.new
    this.tagline        = tagline
    this.value          = "http://source/of/artifacts/version/"
    a_status            = this.one_job
    if a_status.nil? || a_status['status'] == 'fail'
      return 'none'
    else
      ver_it1 = a_status['result'].first
      @result = ver_it1['version']
    end
    return @result
  end
end
