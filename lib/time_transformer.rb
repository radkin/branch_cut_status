# Manipulate status data
class TimeTransformer
  require 'action_view'
  include ActionView::Helpers::DateHelper

  attr_accessor :status, :zone

  def find_human
    if @status['id']
      bi            = "#{@status['id']}-#{@zone}}"
      from_time     = DateTime.strptime("#{bi}", '%Y-%m-%d_%H-%M-%S-%Z')
      to_time       = Time.now 
      @my_buildid   = distance_of_time_in_words(from_time, to_time) 
    else
      @my_buildid   = 'none'
    end
  end
  def pretty_time
    bi              = @status['id']
    bi_tail_step1   = bi.split(/_/)[0]
    # change tail to read %M%D%YY instead of %YY%M%D
    bi_tail_YY      = bi_tail_step1.split(/-/)[0]
    bi_tail_M       = bi_tail_step1.split(/-/)[1]
    bi_tail_D       = bi_tail_step1.split(/-/)[2]
    bi_tail         = "#{bi_tail_M}-#{bi_tail_D}-#{bi_tail_YY}"
    bi_head1        = bi.split(/_/)[1]
    bi_head         = bi_head1.gsub! '-', ':'
    my_buildid     = "#{bi_head} #{bi_tail}"
    my_buildid
  end
end
