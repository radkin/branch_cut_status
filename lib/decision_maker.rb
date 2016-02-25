class DecisionMaker

  require_relative 'time_transformer'

  attr_accessor :status, :human, :key, :value, :zone, :art_version

  def decide
    @this_report = {}
    if @status['building']  == false && @status['result'] == 'SUCCESS'
      my                    = DecisionMaker.new
      my.status             = @status
      my.human              = @human
      my.value              = value
      @my_buildid           = my.humanize_this
      @this_report["#{@key}"] = {
        'status'    => 'SUCCESS',
        'build_id'  => @my_buildid,
        'uri'       => value,
        'ver'       => @art_version
      }
    elsif @status['result'] == 'FAILURE' || @status['building']  == true
      my_last_success         = Status.new
      my_last_success.tagline = 'lastSuccessfulBuild/api/json'
      my_last_success.value   = value
      last_success            = my_last_success.one_job
      my                      = DecisionMaker.new
      my.status               = last_success
      my.human                = @human
      my.value                = value
      @my_buildid             = my.humanize_this
      @this_report["#{@key}"] = {
        'status'    => @status['result'],
        'build_id'  => @my_buildid,
        'uri'       => value,
        'ver'       => @art_version
      }
    end
    @this_report
  end
  def humanize_this
    # only needed until we make tzones consistent
    host_it1      = value.split(/\//)[2]
    host          = host_it1.split(/:/)[0]
    if host == 'larry' || host == 'moe'
      @zone = 'PDT'
    else
      @zone = 'EDT'
    end
    # end of only needed til tzones consistent
    my_ugly_id            = TimeTransformer.new
    my_ugly_id.status     = @status
    my_ugly_id.zone       = @zone
    if @human             == true
      @my_buildid         = my_ugly_id.find_human
    else
      @my_buildid         = my_ugly_id.pretty_time
    end
    return @my_buildid
  end
end

